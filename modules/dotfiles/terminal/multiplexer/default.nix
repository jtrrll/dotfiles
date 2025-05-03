{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "locked";
        show_release_notes = false;
        show_startup_tips = false;
      };
    };

    home = {
      file.zellij-layouts = {
        source = ./layouts;
        target = ".config/zellij/layouts";
      };
    };
  };
}
