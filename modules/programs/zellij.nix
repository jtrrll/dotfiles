{constants, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      themes.default = with constants.COLOR; {
        bg = DARK_GRAY;
        fg = SILVER;
        black = BLACK;
        blue = BLUE;
        cyan = CYAN;
        green = GREEN;
        magenta = PINK;
        red = RED;
        white = SILVER;
        yellow = YELLOW;
        orange = ORANGE;
      };
    };
  };
}
