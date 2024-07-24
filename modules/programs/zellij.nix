{COLORS, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      themes.default = {
        bg = COLORS.DARK_GRAY;
        fg = COLORS.SILVER;
        black = COLORS.BLACK;
        blue = COLORS.BLUE;
        cyan = COLORS.CYAN;
        green = COLORS.GREEN;
        magenta = COLORS.PINK;
        red = COLORS.RED;
        white = COLORS.SILVER;
        yellow = COLORS.YELLOW;
        orange = COLORS.ORANGE;
      };
    };
  };
}
