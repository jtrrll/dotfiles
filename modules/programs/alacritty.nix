{colors, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = colors.GRAY;
          blue = colors.BLUE;
          cyan = colors.CYAN;
          green = colors.TEAL;
          magenta = colors.PINK;
          red = colors.ORANGE;
          white = colors.WHITE;
          yellow = colors.YELLOW;
        };
        normal = {
          black = colors.BLACK;
          blue = colors.BLUE;
          cyan = colors.CYAN;
          green = colors.GREEN;
          magenta = colors.PINK;
          red = colors.RED;
          white = colors.SILVER;
          yellow = colors.YELLOW;
        };
        primary = {
          background = colors.DARK_GRAY;
          foreground = colors.SILVER;
          bright_foreground = colors.WHITE;
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
