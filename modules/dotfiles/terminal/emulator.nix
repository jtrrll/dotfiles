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
        terminal.shell = "${config.programs.fish.package}/bin/fish";
        window.padding = {
          x = 8;
          y = 8;
        };
      };
    };
  };
}
