{COLOR, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      themes.default = {
        bg = COLOR.DARK_GRAY;
        fg = COLOR.SILVER;
        black = COLOR.BLACK;
        blue = COLOR.BLUE;
        cyan = COLOR.CYAN;
        green = COLOR.GREEN;
        magenta = COLOR.PINK;
        red = COLOR.RED;
        white = COLOR.SILVER;
        yellow = COLOR.YELLOW;
        orange = COLOR.ORANGE;
      };
    };
  };
}
