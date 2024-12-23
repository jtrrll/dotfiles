{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_layout = "sessions";
      };
    };

    home = {
      file.zellij-layouts = {
        source = ./layouts;
        target = ".config/zellij/layouts";
      };
      shellAliases = {
        z = "zellij";
      };
    };
  };
}
