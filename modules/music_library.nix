{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager = {
    dotfiles =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        config = lib.mkMerge [
          {
            programs.beets.enable = lib.mkDefault true;
            services.musicLibrary.enable = lib.mkDefault true;
          }
          (lib.mkIf config.programs.beets.enable {
            home.packages = [ pkgs.ffmpeg ];
            programs.beets.settings = {
              plugins = [
                "autobpm"
                "badfiles"
                "convert"
                "embedart"
                "fetchart"
                "fish"
                "fuzzy"
                "lastgenre"
                "lyrics"
                "musicbrainz"
                "thumbnails"
                "types"
              ];
              lyrics.synced = true;
            };
          })
        ];
      };
    musicLibrary =
      {
        config,
        lib,
        ...
      }:
      {
        options.services.musicLibrary = {
          enable = lib.mkEnableOption "a curated music library";
        };

        config = lib.mkIf config.services.musicLibrary.enable {
          home.file.musicLibrary = {
            target = "music_library/README.md";
            text = ''
              # ~/music_library

              A library directory for music.

            '';
          };
          programs.beets.settings = lib.mkIf config.programs.beets.enable {
            directory = "${config.home.homeDirectory}/music_library";
            library = "${config.home.homeDirectory}/music_library/library.db";
          };
        };
      };
  };
}
