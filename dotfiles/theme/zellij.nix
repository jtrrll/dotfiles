{
  config,
  constants,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
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
