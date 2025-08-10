{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.file-system.enable {
    home.file.music = {
      target = "music/README.md";
      text = ''
        # ~/music

        A library directory for music.

        ## Services

        <!-- TODO: Implement services -->
        1. Monthly beets update
        2. Monthly snekcheck

      '';
    };
  };
}
