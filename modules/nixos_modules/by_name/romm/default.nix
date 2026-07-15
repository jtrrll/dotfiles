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
          default = pkgs.romm-image;
          defaultText = lib.literalExpression "pkgs.romm-image";
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
          description = "Base directory for RomM persistent data (resources, assets, config, redis).";
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

        # RomM does not ship a database; consumers bring their own (a sibling
        # container, a native NixOS database service, or an external host).
        # These options describe how RomM connects to it. The password is a
        # secret and must be supplied via `environmentFiles` as `DB_PASSWD`.
        database = {
          driver = lib.mkOption {
            type = lib.types.enum [
              "mariadb"
              "mysql"
              "postgresql"
            ];
            default = "mariadb";
            description = "Database driver RomM connects with (ROMM_DB_DRIVER).";
          };

          host = lib.mkOption {
            type = lib.types.str;
            example = "romm-db";
            description = "Host name of the database RomM connects to (DB_HOST).";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = if cfg.database.driver == "postgresql" then 5432 else 3306;
            defaultText = lib.literalExpression ''if driver == "postgresql" then 5432 else 3306'';
            description = "Port of the database RomM connects to (DB_PORT).";
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = "romm";
            description = "Database name RomM connects to (DB_NAME).";
          };

          user = lib.mkOption {
            type = lib.types.str;
            default = "romm";
            description = "Database user RomM connects as (DB_USER).";
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
            - `DB_PASSWD` (must match the database user's password)
            - `ROMM_AUTH_SECRET_KEY` (generate with `openssl rand -hex 32`)

            Optionally, metadata provider credentials such as
            `IGDB_CLIENT_ID`/`IGDB_CLIENT_SECRET`, `STEAMGRIDDB_API_KEY`,
            `SCREENSCRAPER_USER`/`SCREENSCRAPER_PASSWORD`, etc.

            Provide these via a secrets manager (e.g. sops-nix) so they are
            never written to the Nix store.
          '';
        };

        extraOptions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "--network=host" ];
          description = "Extra command-line options passed to the RomM container runtime.";
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

        systemd.tmpfiles.rules = [
          "d ${cfg.dataDir} 0750 root root -"
          "d ${cfg.dataDir}/resources 0750 1000 1000 -"
          "d ${cfg.dataDir}/assets 0750 1000 1000 -"
          "d ${cfg.dataDir}/config 0750 1000 1000 -"
          "d ${cfg.dataDir}/redis 0750 1000 1000 -"
          "d ${cfg.libraryDir} 0750 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.romm = {
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
          inherit (cfg) extraOptions;
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
            description = "Verify RomM starts against an external database and serves HTTP";
          }
          (
            pkgs.testers.runNixOSTest {
              name = "romm";
              globalTimeout = 60 * 3;
              extraBaseModules.imports = [ module ];

              nodes.server =
                { pkgs, ... }:
                {
                  virtualisation = {
                    diskSize = 1024 * 4;
                    podman.enable = true;
                    oci-containers.backend = "podman";
                  };

                  # Bring-your-own database: a native MariaDB on the host.
                  services.mysql = {
                    enable = true;
                    package = pkgs.mariadb;
                    initialDatabases = [ { name = "romm"; } ];
                    initialScript = pkgs.writeText "romm-db-init" ''
                      CREATE USER IF NOT EXISTS 'romm'@'%' IDENTIFIED BY 'testpassword';
                      GRANT ALL PRIVILEGES ON romm.* TO 'romm'@'%';
                      FLUSH PRIVILEGES;
                    '';
                  };

                  networking.firewall.allowedTCPPorts = [ 3306 ];

                  services.romm = {
                    enable = true;
                    # Reach the host's MariaDB from inside the container.
                    extraOptions = [ "--network=host" ];
                    database.host = "127.0.0.1";
                    environmentFiles = [
                      (pkgs.writeText "romm-app-env" ''
                        DB_PASSWD=testpassword
                        ROMM_AUTH_SECRET_KEY=0000000000000000000000000000000000000000000000000000000000000000
                      '')
                    ];
                  };
                };

              testScript = ''
                server.wait_for_unit("mysql.service", timeout=90)
                server.wait_for_open_port(3306, timeout=90)
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
