let
  module =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.romm;

      inherit (config.virtualisation.oci-containers) backend;

      # Coerce a freeform settings value to the string form expected by a
      # container environment variable.
      renderValue = value: if lib.isBool value then lib.boolToString value else toString value;

      renderSettings =
        settings: lib.mapAttrs (_: renderValue) (lib.filterAttrs (_: v: v != null) settings);

      settingsType = lib.types.attrsOf (
        lib.types.nullOr (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]
        )
      );
    in
    {
      options.services.romm = {
        enable = lib.mkEnableOption "RomM, a self-hosted ROM manager and player";

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

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Host port to expose the RomM web UI on.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to open the firewall for RomM's port.";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/romm";
          description = "Base directory for RomM persistent data (resources, assets, config, redis, database).";
        };

        libraryDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/romm/library";
          description = ''
            Directory containing ROMs and BIOS files.
            See <https://docs.romm.app/latest/getting-started/folder-structure/> for the expected layout.
          '';
        };

        baseUrl = lib.mkOption {
          type = lib.types.str;
          default = "http://0.0.0.0";
          description = "Public URL of this RomM instance (ROMM_BASE_URL).";
        };

        logLevel = lib.mkOption {
          type = lib.types.enum [
            "DEBUG"
            "INFO"
            "WARNING"
            "ERROR"
            "CRITICAL"
          ];
          default = "INFO";
          description = "Application log level (LOGLEVEL).";
        };

        database = {
          driver = lib.mkOption {
            type = lib.types.enum [
              "mariadb"
              "mysql"
              "postgresql"
            ];
            default = "mariadb";
            description = "Database driver (ROMM_DB_DRIVER).";
          };

          host = lib.mkOption {
            type = lib.types.str;
            default = "romm-db";
            description = "Database host (DB_HOST).";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 3306;
            description = "Database port (DB_PORT).";
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = "romm";
            description = "Database name (DB_NAME / MARIADB_DATABASE).";
          };

          user = lib.mkOption {
            type = lib.types.str;
            default = "romm";
            description = "Database user (DB_USER / MARIADB_USER).";
          };

          image = lib.mkOption {
            type = lib.types.package;
            default = pkgs.dockerTools.pullImage {
              imageName = "mariadb";
              imageDigest = "sha256:3b4dfcc32247eb07adbebec0793afae2a8eafa6860ec523ee56af4d3dec42f7f";
              hash = "sha256-tACQsoe0sOUjI2J7XaF4yemlgzSO31XidTgur8NKmes=";
              finalImageName = "mariadb";
              finalImageTag = "11.4";
            };
            description = "Database container image derivation.";
          };

          environmentFiles = lib.mkOption {
            type = lib.types.listOf lib.types.path;
            default = [ ];
            example = lib.literalExpression ''[ config.sops.secrets."romm/db-env".path ]'';
            description = ''
              Environment files for the database container. Must define the
              database secrets:
              - `MARIADB_ROOT_PASSWORD`
              - `MARIADB_PASSWORD` (must match the RomM app's `DB_PASSWD`)

              Provide these via a secrets manager (e.g. sops-nix) so they are
              never written to the Nix store.
            '';
          };

          settings = lib.mkOption {
            type = settingsType;
            default = { };
            description = ''
              Extra environment variables for the database container, merged
              over the module-managed defaults.
            '';
          };
        };

        settings = lib.mkOption {
          type = settingsType;
          default = { };
          example = lib.literalExpression ''
            {
              HASHEOUS_API_ENABLED = true;
              WEB_SERVER_CONCURRENCY = 4;
            }
          '';
          description = ''
            Environment variables for the RomM application container, merged
            over the module-managed defaults. Any variable documented at
            <https://docs.romm.app/latest/reference/environment-variables/>
            may be set here.

            Do not put secrets here (they would land in the world-readable Nix
            store). Use {option}`services.romm.environmentFiles` instead.
          '';
        };

        environmentFiles = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          example = lib.literalExpression ''[ config.sops.secrets."romm/app-env".path ]'';
          description = ''
            Environment files for the RomM application container. Must define
            the application secrets:
            - `DB_PASSWD` (must match the database's `MARIADB_PASSWORD`)
            - `ROMM_AUTH_SECRET_KEY` (generate with `openssl rand -hex 32`)

            Optionally, metadata provider credentials such as
            `IGDB_CLIENT_ID`/`IGDB_CLIENT_SECRET`, `STEAMGRIDDB_API_KEY`,
            `SCREENSCRAPER_USER`/`SCREENSCRAPER_PASSWORD`, etc.

            Provide these via a secrets manager (e.g. sops-nix) so they are
            never written to the Nix store.
          '';
        };

        metadataProviders = {
          hasheous.enable = lib.mkEnableOption "the Hasheous metadata provider (HASHEOUS_API_ENABLED)";
          launchbox.enable = lib.mkEnableOption "the LaunchBox metadata provider (LAUNCHBOX_API_ENABLED)";
          playmatch.enable = lib.mkEnableOption "the PlayMatch metadata provider (PLAYMATCH_API_ENABLED)";
          flashpoint.enable = lib.mkEnableOption "the Flashpoint metadata provider (FLASHPOINT_API_ENABLED)";
          hltb.enable = lib.mkEnableOption "the HowLongToBeat metadata provider (HLTB_API_ENABLED)";
          tgdb.enable = lib.mkEnableOption "the TheGamesDB metadata provider (TGDB_API_ENABLED)";

          retroachievements.cacheRefreshDays = lib.mkOption {
            type = lib.types.ints.positive;
            default = 30;
            description = ''
              RetroAchievements metadata cache refresh interval in days
              (REFRESH_RETROACHIEVEMENTS_CACHE_DAYS).

              The RetroAchievements API key is a secret; set
              `RETROACHIEVEMENTS_API_KEY` in
              {option}`services.romm.environmentFiles`.
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        services.romm.settings = {
          ROMM_BASE_URL = lib.mkDefault cfg.baseUrl;
          ROMM_DB_DRIVER = lib.mkDefault cfg.database.driver;
          DB_HOST = lib.mkDefault cfg.database.host;
          DB_PORT = lib.mkDefault cfg.database.port;
          DB_NAME = lib.mkDefault cfg.database.name;
          DB_USER = lib.mkDefault cfg.database.user;
          LOGLEVEL = lib.mkDefault cfg.logLevel;

          HASHEOUS_API_ENABLED = lib.mkDefault cfg.metadataProviders.hasheous.enable;
          LAUNCHBOX_API_ENABLED = lib.mkDefault cfg.metadataProviders.launchbox.enable;
          PLAYMATCH_API_ENABLED = lib.mkDefault cfg.metadataProviders.playmatch.enable;
          FLASHPOINT_API_ENABLED = lib.mkDefault cfg.metadataProviders.flashpoint.enable;
          HLTB_API_ENABLED = lib.mkDefault cfg.metadataProviders.hltb.enable;
          TGDB_API_ENABLED = lib.mkDefault cfg.metadataProviders.tgdb.enable;
          REFRESH_RETROACHIEVEMENTS_CACHE_DAYS = lib.mkDefault cfg.metadataProviders.retroachievements.cacheRefreshDays;
        };

        services.romm.database.settings = {
          MARIADB_DATABASE = lib.mkDefault cfg.database.name;
          MARIADB_USER = lib.mkDefault cfg.database.user;
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.dataDir} 0750 root root -"
          "d ${cfg.dataDir}/resources 0750 1000 1000 -"
          "d ${cfg.dataDir}/assets 0750 1000 1000 -"
          "d ${cfg.dataDir}/config 0750 1000 1000 -"
          "d ${cfg.dataDir}/db 0750 999 999 -"
          "d ${cfg.dataDir}/redis 0750 1000 1000 -"
          "d ${cfg.libraryDir} 0750 1000 1000 -"
        ];

        systemd.services."create-romm-network" = {
          description = "Create container network for RomM";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          before = [
            "${backend}-romm.service"
            "${backend}-romm-db.service"
          ];
          requiredBy = [
            "${backend}-romm.service"
            "${backend}-romm-db.service"
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            ${backend} network inspect romm-network >/dev/null 2>&1 || \
              ${backend} network create romm-network
          '';
          path =
            if backend == "docker" then
              [ config.virtualisation.docker.package ]
            else
              [ config.virtualisation.podman.package ];
        };

        virtualisation.oci-containers.containers = {
          romm = {
            imageFile = cfg.image;
            image = "${cfg.image.imageName}:${cfg.image.imageTag}";
            inherit (cfg) environmentFiles;
            environment = renderSettings cfg.settings;
            ports = [ "${toString cfg.port}:8080" ];
            volumes = [
              "${cfg.dataDir}/resources:/romm/resources"
              "${cfg.dataDir}/assets:/romm/assets"
              "${cfg.dataDir}/config:/romm/config"
              "${cfg.dataDir}/redis:/redis-data"
              "${cfg.libraryDir}:/romm/library"
            ];
            dependsOn = [ "romm-db" ];
            extraOptions = [ "--network=romm-network" ];
          };

          romm-db = {
            imageFile = cfg.database.image;
            image = "${cfg.database.image.imageName}:${cfg.database.image.imageTag}";
            environmentFiles = cfg.database.environmentFiles;
            environment = renderSettings cfg.database.settings;
            volumes = [
              "${cfg.dataDir}/db:/var/lib/mysql"
            ];
            extraOptions = [ "--network=romm-network" ];
          };
        };

        networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
      };
    };
  moduleTests =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.romm;
    in
    {
      tests."romm/http" = lib.mkIf cfg.enable (
        lib.addMetaAttrs
          {
            description = "Verify RomM containers start and serve HTTP";
          }
          (
            pkgs.testers.runNixOSTest {
              name = "romm";
              globalTimeout = 60 * 3;
              extraBaseModules.imports = [ module ];

              nodes.server = {
                virtualisation = {
                  diskSize = 1024 * 4;
                  podman.enable = true;
                  oci-containers.backend = "podman";
                };

                services.romm = {
                  enable = true;
                  environmentFiles = [
                    (pkgs.writeText "romm-app-env" ''
                      DB_PASSWD=testpassword
                      ROMM_AUTH_SECRET_KEY=0000000000000000000000000000000000000000000000000000000000000000
                    '')
                  ];
                  database.environmentFiles = [
                    (pkgs.writeText "romm-db-env" ''
                      MARIADB_PASSWORD=testpassword
                      MARIADB_ROOT_PASSWORD=rootpassword
                    '')
                  ];
                };
              };

              testScript = ''
                server.wait_for_unit("podman-romm-db.service", timeout=90)
                server.wait_for_unit("podman-romm.service", timeout=90)
                server.wait_for_open_port(8080, timeout=90)
                server.succeed("curl -sf http://localhost:8080")
              '';
            }
          )
      );
    };
in
{
  imports = [
    module
    moduleTests
  ];
}
