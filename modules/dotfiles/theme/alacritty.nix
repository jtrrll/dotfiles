{
  config,
  constants,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.alacritty.settings = {
      colors = with constants.COLOR; {
        bright = {
          black = GRAY;
          blue = BLUE;
          cyan = CYAN;
          green = TEAL;
          magenta = PINK;
          red = ORANGE;
          white = WHITE;
          yellow = YELLOW;
        };
        normal = {
          black = BLACK;
          blue = BLUE;
          cyan = CYAN;
          green = GREEN;
          magenta = PINK;
          red = RED;
          white = SILVER;
          yellow = YELLOW;
        };
        primary = {
          background = DARK_GRAY;
          foreground = SILVER;
          bright_foreground = WHITE;
        };
      };
      cursor = {
        blink_interval = 500;
        style = {
          blinking = "Always";
          shape = "Beam";
        };
        unfocused_hollow = true;
      };
      font.normal = {
        family = "Hack Nerd Font Mono";
        style = "Regular";
      };
      window.padding = {
        x = 8;
        y = 8;
      };
    };
    stylix.targets.alacritty.enable = false;
  };
}
