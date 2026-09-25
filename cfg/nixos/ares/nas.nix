# Temporary NAS/media server configuration for ares.
# TODO: Move this to a dedicated NAS host once hardware is acquired.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  calibreLibraryName = "calibre-library";
  calibreLibraryDir = "/var/lib/${calibreLibraryName}";
  jellyfinPort = 8096;

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
  systemd.services.calibre-web = {
    requires = [ "calibre-library-init.service" ];
    after = [ "calibre-library-init.service" ];
  };

  systemd.services.calibre-library-init = {
    description = "Initialize the Calibre ebook library";
    environment.CALIBRE_CONFIG_DIRECTORY = "${calibreLibraryDir}/.calibre";
    serviceConfig = {
      Type = "oneshot";
      User = config.services.calibre-web.user;
      Group = config.services.calibre-web.group;
      StateDirectory = calibreLibraryName;
      StateDirectoryMode = "0750";
    };
    script = ''
      if [ ! -e ${lib.escapeShellArg "${calibreLibraryDir}/metadata.db"} ]; then
        ${config.services.calibre-web.calibrePackage}/bin/calibredb --with-library ${lib.escapeShellArg calibreLibraryDir} list
      fi
    '';
  };

  services = {
    # Reverse proxy
    caddy = {
      enable = true;
      openFirewall = true;
      virtualHosts =
        lib.mapAttrs'
          (
            name: port:
            lib.nameValuePair "http://${name}.services.lan" {
              extraConfig = "reverse_proxy localhost:${toString port}";
            }
          )
          (
            let
              cfg = config.services;
            in
            {
              bazarr = cfg.bazarr.listenPort;
              calibre = cfg.calibre-web.listen.port;
              forgejo = cfg.forgejo.settings.server.HTTP_PORT;
              jellyfin = jellyfinPort;
              lidarr = cfg.lidarr.settings.server.port;
              prowlarr = cfg.prowlarr.settings.server.port;
              qbittorrent = cfg.qbittorrent.webuiPort;
              radarr = cfg.radarr.settings.server.port;
              romm = cfg.romm.port;
              sonarr = cfg.sonarr.settings.server.port;
            }
          );
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
    qbittorrent = {
      enable = true;
      webuiPort = 8090;
      torrentingPort = 51413;
      serverConfig.Preferences.Downloads.SavePath = "${config.services.qbittorrent.profileDir}/downloads";
    };

    # Music automation
    lidarr.enable = true;

    # ROM manager
    romm = {
      enable = true;
      database = {
        driver = "postgresql";
        host = "127.0.0.1";
      };
      environmentFiles = [ config.sops.templates."romm-app-env".path ];
      metadataProviders.hasheous.enable = true;
    };

    # SQL database
    postgresql = {
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

    # E-book library and Kobo sync
    calibre-web = {
      enable = true;
      openFirewall = true;
      package = pkgs.calibre-web.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ [ pkgs.python3Packages.jsonschema ];
      });
      listen.ip = "0.0.0.0";
      options = {
        calibreLibrary = calibreLibraryDir;
        enableBookUploading = true;
        enableKepubify = true;
      };
    };

    # Git forge
    forgejo = {
      enable = true;
      settings.server = {
        DOMAIN = "forgejo.services.lan";
        ROOT_URL = "http://forgejo.services.lan/";
      };
    };

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
          path = "${config.services.qbittorrent.profileDir}/downloads";
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
        roms = {
          path = config.services.romm.libraryDir;
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    jellyfinPort
    config.services.romm.port
    config.services.qbittorrent.torrentingPort
  ];

  environment.systemPackages = [ config.services.calibre-web.calibrePackage ];

  systemd.tmpfiles.settings.qbittorrent-downloads."${config.services.qbittorrent.profileDir}/downloads"."d" =
    {
      mode = "0755";
      user = config.services.qbittorrent.user;
      group = config.services.qbittorrent.group;
    };

  # Lidarr post-import script for embedding lyrics via beets.
  # Configure in Lidarr UI: Settings → Connect → Custom Script → path:
  #   ${lidarrPostImport}
  environment.etc."lidarr/post-import".source = lidarrPostImport;

  sops.secrets = {
    "romm/db-password" = {
      key = "db-password";
      sopsFile = ./secrets/romm.yaml;
    };
    "romm/auth-secret-key" = {
      key = "auth-secret-key";
      sopsFile = ./secrets/romm.yaml;
    };
    "romm/retroachievements-api-key" = {
      key = "retroachievements-api-key";
      sopsFile = ./secrets/romm.yaml;
    };
  };

  sops.templates."romm-app-env".content = ''
    DB_PASSWD=${config.sops.placeholder."romm/db-password"}
    ROMM_AUTH_SECRET_KEY=${config.sops.placeholder."romm/auth-secret-key"}
    RETROACHIEVEMENTS_API_KEY=${config.sops.placeholder."romm/retroachievements-api-key"}
  '';

  # Set the PostgreSQL `romm` role's password from the same secret, so it
  # always matches RomM's DB_PASSWD.
  systemd.services.romm-db-password = {
    description = "Set the RomM PostgreSQL role password";
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    before = [ "romm.service" ];
    requiredBy = [ "romm.service" ];
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
}
