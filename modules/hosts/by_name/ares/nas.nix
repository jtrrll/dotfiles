# Temporary NAS/media server configuration for ares.
# TODO: Move this to a dedicated NAS host once hardware is acquired.
{ config, pkgs, ... }:
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
      openFirewall = true;
      settings.rpc-url = "/transmission/";
    };

    # Music automation
    lidarr.enable = true;

    # ROM manager
    romm = {
      enable = true;
      environmentFile = "/run/secrets/romm.env";
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
}
