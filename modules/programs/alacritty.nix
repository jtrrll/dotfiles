{COLOR, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = COLOR.GRAY;
          blue = COLOR.BLUE;
          cyan = COLOR.CYAN;
          green = COLOR.TEAL;
          magenta = COLOR.PINK;
          red = COLOR.ORANGE;
          white = COLOR.WHITE;
          yellow = COLOR.YELLOW;
        };
        normal = {
          black = COLOR.BLACK;
          blue = COLOR.BLUE;
          cyan = COLOR.CYAN;
          green = COLOR.GREEN;
          magenta = COLOR.PINK;
          red = COLOR.RED;
          white = COLOR.SILVER;
          yellow = COLOR.YELLOW;
        };
        primary = {
          background = COLOR.DARK_GRAY;
          foreground = COLOR.SILVER;
          bright_foreground = COLOR.WHITE;
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
