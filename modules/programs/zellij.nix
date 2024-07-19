{colors, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      themes.default = {
        bg = colors.DARK_GRAY;
        fg = colors.SILVER;
        black = colors.BLACK;
        blue = colors.BLUE;
        cyan = colors.CYAN;
        green = colors.GREEN;
        magenta = colors.PINK;
        red = colors.RED;
        white = colors.SILVER;
        yellow = colors.YELLOW;
        orange = colors.ORANGE;
      };
    };
  };
}
