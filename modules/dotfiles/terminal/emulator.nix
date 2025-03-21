{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          env.SHELL = "${config.programs.fish.package}/bin/fish";
          terminal.shell.program = "${config.programs.zellij.package}/bin/zellij";
        };
      };
      ghostty = {
        enable = true;
        settings.command = "SHELL=${config.programs.fish.package}/bin/fish ${config.programs.zellij.package}/bin/zellij";
      };
    };
  };
}
