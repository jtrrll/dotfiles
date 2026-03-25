{
  config,
  lib,
  pkgs,
  options,
  ...
}:
{
  config = lib.mkMerge [
    { programs.zellij.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.zellij.enable {
      home.packages = [ pkgs.watch ];
      programs.zellij.settings = {
        show_release_notes = false;
        show_startup_tips = false;
        themes.default =
          let
            constants = import ../../../../../constants.nix;
          in
          with constants.COLOR;
          {
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
    })
    (lib.mkIf (options ? stylix) { stylix.targets.zellij.enable = false; })
  ];
}
