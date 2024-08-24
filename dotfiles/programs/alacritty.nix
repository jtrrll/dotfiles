{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        cursor = {
          blink_interval = 500;
          style = {
            blinking = "Always";
            shape = "Beam";
          };
          unfocused_hollow = true;
        };
        window.padding = {
          x = 8;
          y = 8;
        };
      };
    };
  };
}
