{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.music =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.dotfiles.musicLibrary = {
        enable = lib.mkEnableOption "jtrrll's music library configuration" // {
          default = true;
        };
      };

      config = lib.mkIf config.dotfiles.musicLibrary.enable {
        home = {
          file.musicLibrary = {
            target = "music_library/README.md";
            text = ''
              # ~/music_library

              A library directory for music.

            '';
          };
          packages = [ pkgs.ffmpeg ];
        };
        programs.beets = {
          enable = true;
          settings = {
            directory = "~/music_library";
            library = "~/music_library/library.db";
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
        };
      };
    };
}
