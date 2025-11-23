{ constants }:
{
  config,
  lib,
  options,
  ...
}:
{
  imports = [
    ./layouts
  ];

  config = lib.mkIf config.jtrrllDotfiles.terminal.enable (
    lib.mkMerge [
      {
        programs.zellij = {
          enable = true;
          settings = {
            show_release_notes = false;
            show_startup_tips = false;
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
      }
      (if options ? stylix then { stylix.targets.zellij.enable = false; } else { })
    ]
  );
}
