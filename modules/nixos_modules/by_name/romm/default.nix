{
  config,
  lib,
  nixosModules ? [ ],
  pkgs,
  ...
}:
let
  cfg = config.services.romm;
in
{
  options.services.romm = {
    enable = lib.mkEnableOption "RomM, a self-hosted ROM manager and player";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to expose the RomM web UI on the host.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/romm";
      description = "Base directory for RomM persistent data (database, redis, resources, assets, config).";
    };

    libraryDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/romm/library";
      description = ''
        Directory containing ROMs and BIOS files.
        See https://docs.romm.app/latest/Getting-Started/Folder-Structure/ for the expected layout.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to an environment file containing secrets. Must define at minimum:
        - DB_PASSWD and MARIADB_PASSWORD (same value)
        - MARIADB_ROOT_PASSWORD
        - ROMM_AUTH_SECRET_KEY (generate with `openssl rand -hex 32`)

        Optionally for metadata providers:
        - IGDB_CLIENT_ID and IGDB_CLIENT_SECRET
        - STEAMGRIDDB_API_KEY
        - SCREENSCRAPER_USER and SCREENSCRAPER_PASSWORD
      '';
    };

    image = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dockerTools.pullImage {
        imageName = "rommapp/romm";
        imageDigest = "sha256:2b7a1714b287f69b081ad2a63bb8c2fa673666a17b2f21322b580b0cd51cb266";
        hash = "sha256-/aYg4BVUAsRxM/lo9e+Vxlj0kk/Gs9eTXa6hnrCrqLA=";
        finalImageName = "rommapp/romm";
        finalImageTag = "4.8.1";
      };
      description = "RomM container image derivation.";
    };

    mariadbImage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dockerTools.pullImage {
        imageName = "mariadb";
        imageDigest = "sha256:3b4dfcc32247eb07adbebec0793afae2a8eafa6860ec523ee56af4d3dec42f7f";
        hash = "sha256-tACQsoe0sOUjI2J7XaF4yemlgzSO31XidTgur8NKmes=";
        finalImageName = "mariadb";
        finalImageTag = "11.4";
      };
      description = "MariaDB container image derivation.";
    };

    valkeyImage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dockerTools.pullImage {
        imageName = "valkey/valkey";
        imageDigest = "sha256:9917e842cfc3220e4ac3e819eb98a975cc171eff5e532c79cb75558030eb9078";
        hash = "sha256-EwCBctbs4jVPH5HuY7KXIWlC8M3HxmonTQpzTuEHdps=";
        finalImageName = "valkey/valkey";
        finalImageTag = "8";
      };
      description = "Valkey (Redis-compatible) container image derivation.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for RomM's port.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root -"
      "d ${cfg.dataDir}/resources 0750 root root -"
      "d ${cfg.dataDir}/assets 0750 root root -"
      "d ${cfg.dataDir}/config 0750 root root -"
      "d ${cfg.dataDir}/db 0750 root root -"
      "d ${cfg.dataDir}/redis 0750 root root -"
      "d ${cfg.libraryDir} 0750 root root -"
    ];

    systemd.services."create-romm-network" = {
      description = "Create container network for RomM";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      before = [
        "${config.virtualisation.oci-containers.backend}-romm.service"
        "${config.virtualisation.oci-containers.backend}-romm-db.service"
        "${config.virtualisation.oci-containers.backend}-romm-redis.service"
      ];
      requiredBy = [
        "${config.virtualisation.oci-containers.backend}-romm.service"
        "${config.virtualisation.oci-containers.backend}-romm-db.service"
        "${config.virtualisation.oci-containers.backend}-romm-redis.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script =
        let
          inherit (config.virtualisation.oci-containers) backend;
        in
        ''
          ${backend} network inspect romm-network >/dev/null 2>&1 || \
            ${backend} network create romm-network
        '';
      path =
        if config.virtualisation.oci-containers.backend == "docker" then
          [ config.virtualisation.docker.package ]
        else
          [ config.virtualisation.podman.package ];
    };

    virtualisation.oci-containers.containers = {
      romm = {
        imageFile = cfg.image;
        image = "${cfg.image.imageName}:${cfg.image.imageTag}";
        environmentFiles = [ cfg.environmentFile ];
        environment = {
          DB_HOST = "romm-db";
          DB_NAME = "romm";
          DB_USER = "romm";
          REDIS_HOST = "romm-redis";
          REDIS_PORT = "6379";
        };
        ports = [ "${toString cfg.port}:8080" ];
        volumes = [
          "${cfg.dataDir}/resources:/romm/resources"
          "${cfg.dataDir}/assets:/romm/assets"
          "${cfg.dataDir}/config:/romm/config"
          "${cfg.dataDir}/redis:/redis-data"
          "${cfg.libraryDir}:/romm/library"
        ];
        dependsOn = [
          "romm-db"
          "romm-redis"
        ];
        extraOptions = [ "--network=romm-network" ];
      };

      romm-db = {
        imageFile = cfg.mariadbImage;
        image = "${cfg.mariadbImage.imageName}:${cfg.mariadbImage.imageTag}";
        environmentFiles = [ cfg.environmentFile ];
        environment = {
          MARIADB_DATABASE = "romm";
          MARIADB_USER = "romm";
        };
        volumes = [
          "${cfg.dataDir}/db:/var/lib/mysql"
        ];
        extraOptions = [ "--network=romm-network" ];
      };

      romm-redis = {
        imageFile = cfg.valkeyImage;
        image = "${cfg.valkeyImage.imageName}:${cfg.valkeyImage.imageTag}";
        volumes = [
          "${cfg.dataDir}/redis:/data"
        ];
        extraOptions = [ "--network=romm-network" ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    tests."romm/http" =
      let
        test = pkgs.testers.runNixOSTest {
          name = "romm";
          globalTimeout = 60 * 3;
          extraBaseModules.imports = nixosModules;

          nodes.server = {
            virtualisation = {
              diskSize = 1024 * 4;
              podman.enable = true;
              oci-containers.backend = "podman";
            };

            services.romm = {
              enable = true;
              environmentFile = pkgs.writeText "romm-env" ''
                DB_PASSWD=testpassword
                MARIADB_PASSWORD=testpassword
                MARIADB_ROOT_PASSWORD=rootpassword
                ROMM_AUTH_SECRET_KEY=0000000000000000000000000000000000000000000000000000000000000000
              '';
            };
          };

          testScript = ''
            server.wait_for_unit("podman-romm-db.service", timeout=90)
            server.wait_for_unit("podman-romm-redis.service", timeout=90)
            server.wait_for_unit("podman-romm.service", timeout=90)
            server.wait_for_open_port(8080, timeout=90)
            server.succeed("curl -sf http://localhost:8080")
          '';
        };
      in
      lib.mkIf cfg.enable (
        test
        // {
          meta = test.meta // {
            description = "Verify RomM containers start and serve HTTP";
          };
        }
      );
  };
}
