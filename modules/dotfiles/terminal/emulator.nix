{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        cursor = {
          blink_interval = 500;
          style.blinking = "Always";
          unfocused_hollow = true;
        };
        env.SHELL = "${config.programs.fish.package}/bin/fish";
        terminal.shell.program = "${config.programs.zellij.package}/bin/zellij";
        window.padding = {
          x = 8;
          y = 8;
        };
      };
    };
  };
}
