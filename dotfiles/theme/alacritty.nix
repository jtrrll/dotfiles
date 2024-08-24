{
  config,
  constants,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    programs.alacritty = {
      settings = {
        colors = with constants.COLOR; {
          bright = {
            black = GRAY;
            blue = BLUE;
            cyan = CYAN;
            green = TEAL;
            magenta = PINK;
            red = ORANGE;
            white = WHITE;
            yellow = YELLOW;
          };
          normal = {
            black = BLACK;
            blue = BLUE;
            cyan = CYAN;
            green = GREEN;
            magenta = PINK;
            red = RED;
            white = SILVER;
            yellow = YELLOW;
          };
          primary = {
            background = DARK_GRAY;
            foreground = SILVER;
            bright_foreground = WHITE;
          };
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
      };
    };
    stylix.targets.alacritty.enable = false;
  };
}
