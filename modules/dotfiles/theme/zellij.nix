{
  config,
  constants,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.zellij = {
      settings.themes.default = with constants.COLOR; {
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
    stylix.targets.zellij.enable = false;
  };
}
