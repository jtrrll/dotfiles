{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.musicLibrary.enable {
    home.file.musicLibrary = {
      target = "music_library/README.md";
      text = ''
        # ~/music_library

        A library directory for music.

        ## Services

        <!-- TODO: Implement services -->
        1. Monthly beets update
        2. Monthly snekcheck

      '';
    };
    programs.beets = {
      enable = true;
      settings = {
        directory = "~/music_library";
        import = {
          copy = false;
          move = false;
        };
        library = "~/music_library/library.db";
        plugins = [
          "autobpm"
          "badfiles"
          "embedart"
          "fetchart"
          "fish"
          "fuzzy"
          "lastgenre"
          "lyrics"
          "thumbnails"
          "types"
        ];
      };
    };
  };

  options.dotfiles.musicLibrary = {
    enable = lib.mkEnableOption "jtrrll's music library configuration";
  };
}
