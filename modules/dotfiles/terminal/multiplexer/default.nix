{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.zellij = {
      enable = true;
      settings.show_startup_tips = false;
    };

    home = {
      file.zellij-layouts = {
        source = ./layouts;
        target = ".config/zellij/layouts";
      };
    };
  };
}
