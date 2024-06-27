{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "#6e7681";
          blue = "#569cd6"; # same as normal
          cyan = "#9cdcfe"; # same as normal
          green = "#4ec9b0";
          magenta = "#c586c0"; # same as normal
          red = "#ce9178";
          white = "#e5e5e5";
          yellow = "#dcdcaa"; # same as normal
        };
        normal = {
          black = "#181818";
          blue = "#569cd6";
          cyan = "#9cdcfe";
          green = "#6a9955";
          magenta = "#c586c0";
          red = "#f44747";
          white = "#cccccc";
          yellow = "#dcdcaa";
        };
        primary = {
          background = "#1f1f1f";
          foreground = "#cccccc";
          bright_foreground = "#e5e5e5";
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
