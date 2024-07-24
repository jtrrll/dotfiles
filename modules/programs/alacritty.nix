{COLORS, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = COLORS.GRAY;
          blue = COLORS.BLUE;
          cyan = COLORS.CYAN;
          green = COLORS.TEAL;
          magenta = COLORS.PINK;
          red = COLORS.ORANGE;
          white = COLORS.WHITE;
          yellow = COLORS.YELLOW;
        };
        normal = {
          black = COLORS.BLACK;
          blue = COLORS.BLUE;
          cyan = COLORS.CYAN;
          green = COLORS.GREEN;
          magenta = COLORS.PINK;
          red = COLORS.RED;
          white = COLORS.SILVER;
          yellow = COLORS.YELLOW;
        };
        primary = {
          background = COLORS.DARK_GRAY;
          foreground = COLORS.SILVER;
          bright_foreground = COLORS.WHITE;
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
      font = {
        bold = {
          family = "Hack Nerd Font Mono";
          style = "Bold";
        };
        bold_italic = {
          family = "Hack Nerd Font Mono";
          style = "Bold Italic";
        };
        italic = {
          family = "Hack Nerd Font Mono";
          style = "Italic";
        };
        normal = {
          family = "Hack Nerd Font Mono";
          style = "Regular";
        };
      };
      window.padding = {
        x = 8;
        y = 8;
      };
    };
  };
}
