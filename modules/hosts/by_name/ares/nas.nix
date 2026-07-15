# Temporary NAS/media server configuration for ares.
# TODO: Move this to a dedicated NAS host once hardware is acquired.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  beetsConfig = pkgs.writeText "beets-config.yaml" ''
    directory: ${config.services.lidarr.dataDir}
    library: ${config.services.lidarr.dataDir}/beets.db
    plugins: lyrics
    lyrics:
      auto: yes
      sources:
        - lrclib
        - google
        - genius
      synced: yes
    import:
      copy: no
      move: no
      write: yes
  '';

  lidarrPostImport = pkgs.writeShellScript "lidarr-post-import" ''
    echo "$lidarr_addedtrackpaths" | tr '|' '\n' | while read -r file; do
      dirname "$file"
    done | sort -u | while read -r dir; do
      ${pkgs.beets}/bin/beet -c ${beetsConfig} import --quiet "$dir"
    done
  '';
in
{
  services = {
    # Reverse proxy
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts.":80".extraConfig =
        let
          cfg = config.services;
        in
        ''
          handle_path /jellyfin/* {
            reverse_proxy localhost:8096
          }
          handle_path /sonarr/* {
            reverse_proxy localhost:8989
          }
          handle_path /radarr/* {
            reverse_proxy localhost:7878
          }
          handle_path /prowlarr/* {
            reverse_proxy localhost:9696
          }
          handle_path /transmission/* {
            reverse_proxy localhost:${toString cfg.transmission.settings.rpc-port}
          }
          handle_path /romm/* {
            reverse_proxy localhost:${toString cfg.romm.port}
          }
          handle_path /lidarr/* {
            reverse_proxy localhost:8686
          }
          handle_path /audiobookshelf/* {
            reverse_proxy localhost:${toString cfg.audiobookshelf.port}
          }
          handle_path /forgejo/* {
            reverse_proxy localhost:${toString cfg.forgejo.settings.server.HTTP_PORT}
          }
          handle_path /bazarr/* {
            reverse_proxy localhost:${toString cfg.bazarr.listenPort}
          }
        '';
    };

    # Media streaming
    jellyfin.enable = true;

    # TV show automation
    sonarr.enable = true;

    # Movie automation
    radarr.enable = true;

    # Indexer manager
    prowlarr.enable = true;

    # Subtitle automation
    bazarr.enable = true;

    # Torrent client
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      openFirewall = true;
      settings.rpc-url = "/transmission/";
    };

    # Music automation
    lidarr.enable = true;

    # ROM manager. Uses the host's native PostgreSQL (see below) rather than a
    # bundled database container. The container shares the host network so it
    # can reach PostgreSQL on 127.0.0.1.
    romm = {
      enable = true;
      extraOptions = [ "--network=host" ];
      database = {
        driver = "postgresql";
        host = "127.0.0.1";
      };
      environmentFiles = [ config.sops.templates."romm-app-env".path ];
    };

    # PostgreSQL database backing RomM.
    postgresql = {
      enable = true;
      ensureDatabases = [ "romm" ];
      ensureUsers = [
        {
          name = "romm";
          ensureDBOwnership = true;
        }
      ];
      # Allow the RomM container (connecting over TCP via --network=host) to
      # authenticate with a password.
      authentication = lib.mkAfter ''
        host romm romm 127.0.0.1/32 scram-sha-256
        host romm romm ::1/128 scram-sha-256
      '';
    };

    # Audiobooks and e-books
    audiobookshelf.enable = true;

    # Git forge
    forgejo.enable = true;

    # Network file shares
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          security = "user";
          "map to guest" = "Bad User";
        };
        downloads = {
          path = "${config.services.transmission.home}/Downloads";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
        music = {
          path = config.services.lidarr.dataDir;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
        audiobooks = {
          path = "/var/lib/${config.services.audiobookshelf.dataDir}";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
        roms = {
          path = config.services.romm.libraryDir;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
      };
    };
  };

  # Lidarr post-import script for embedding lyrics via beets.
  # Configure in Lidarr UI: Settings → Connect → Custom Script → path:
  #   ${lidarrPostImport}
  environment.etc."lidarr/post-import".source = lidarrPostImport;

  # RomM secrets. A single source of truth (romm.yaml) holds the raw database
  # password and auth secret key. Edit with `sops-with-key <file>`.
  sops.secrets = {
    "romm/db-password" = {
      key = "db-password";
      sopsFile = ./secrets/romm.yaml;
    };
    "romm/auth-secret-key" = {
      key = "auth-secret-key";
      sopsFile = ./secrets/romm.yaml;
    };
  };

  # RomM's application env file, rendered at runtime from the decrypted
  # secrets so the values never touch the Nix store.
  sops.templates."romm-app-env".content = ''
    DB_PASSWD=${config.sops.placeholder."romm/db-password"}
    ROMM_AUTH_SECRET_KEY=${config.sops.placeholder."romm/auth-secret-key"}
  '';

  # Set the PostgreSQL `romm` role's password from the same secret, so it
  # always matches RomM's DB_PASSWD.
  systemd.services.romm-db-password = {
    description = "Set the RomM PostgreSQL role password";
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    before = [ "podman-romm.service" ];
    requiredBy = [ "podman-romm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
      LoadCredential = [ "db-password:${config.sops.secrets."romm/db-password".path}" ];
    };
    script = ''
      password="$(cat "$CREDENTIALS_DIRECTORY/db-password")"
      ${config.services.postgresql.package}/bin/psql --no-psqlrc --set ON_ERROR_STOP=1 <<SQL
      ALTER ROLE romm WITH PASSWORD '$password';
      SQL
    '';
  };

  # Live-boot integration test for the RomM + native PostgreSQL wiring. This
  # mirrors the host setup (native PostgreSQL, the romm container on the host
  # network, and the role-password sync unit) but supplies the database
  # password from a plain file instead of sops, since the test VM has no
  # decryption key.
  tests."romm/postgresql" = pkgs.testers.runNixOSTest {
    name = "romm-postgresql";
    globalTimeout = 60 * 5;

    nodes.server =
      { config, pkgs, ... }:
      {
        virtualisation = {
          diskSize = 1024 * 4;
          podman.enable = true;
          oci-containers.backend = "podman";
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "romm" ];
          ensureUsers = [
            {
              name = "romm";
              ensureDBOwnership = true;
            }
          ];
          authentication = lib.mkAfter ''
            host romm romm 127.0.0.1/32 scram-sha-256
            host romm romm ::1/128 scram-sha-256
          '';
        };

        systemd.services.romm-db-password = {
          description = "Set the RomM PostgreSQL role password";
          after = [ "postgresql.service" ];
          requires = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];
          before = [ "podman-romm.service" ];
          requiredBy = [ "podman-romm.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "postgres";
          };
          script = ''
            ${config.services.postgresql.package}/bin/psql --no-psqlrc --set ON_ERROR_STOP=1 <<SQL
            ALTER ROLE romm WITH PASSWORD 'testpassword';
            SQL
          '';
        };

        services.romm = {
          enable = true;
          extraOptions = [ "--network=host" ];
          database = {
            driver = "postgresql";
            host = "127.0.0.1";
          };
          environmentFiles = [
            (pkgs.writeText "romm-app-env" ''
              DB_PASSWD=testpassword
              ROMM_AUTH_SECRET_KEY=0000000000000000000000000000000000000000000000000000000000000000
            '')
          ];
        };
      };

    testScript = ''
      server.wait_for_unit("postgresql.service", timeout=120)
      server.wait_for_unit("romm-db-password.service", timeout=120)
      server.wait_for_unit("podman-romm.service", timeout=180)
      server.wait_for_open_port(8080, timeout=180)
      # RomM only serves successfully once it has connected to and migrated the
      # database, so a healthy HTTP response exercises the full DB path.
      server.wait_until_succeeds("curl -sf http://localhost:8080", timeout=180)
    '';
  };
}
