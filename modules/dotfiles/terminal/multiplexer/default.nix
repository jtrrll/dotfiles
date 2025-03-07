{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.zellij.enable = true;

    home = {
      file.zellij-layouts = {
        source = ./layouts;
        target = ".config/zellij/layouts";
      };
    };
  };
}
