{
  config,
  constants,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.zellij = {
      settings = {
        themes.default = with constants.COLOR; {
          bg = DARK_GRAY;
          fg = SILVER;
          black = DARK_GRAY;
          blue = BLUE;
          cyan = CYAN;
          green = GREEN;
          magenta = PINK;
          red = RED;
          white = SILVER;
          yellow = YELLOW;
          orange = ORANGE;
        };
        ui.pane_frames.rounded_corners = true;
      };
    };
    stylix.targets.zellij.enable = false;
  };
}
