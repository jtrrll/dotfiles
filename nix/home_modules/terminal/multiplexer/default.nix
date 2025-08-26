{ constants }:
{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.terminal.enable (
    lib.mkMerge [
      {
        programs.zellij = {
          enable = true;
          settings = {
            default_mode = "locked";
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

        home.file.zellij-layouts = builtins.addErrorContext "while parsing Zellij layouts" (
          let
            source = ./layouts;
          in
          assert builtins.all (lib.hasSuffix ".kdl") (builtins.attrNames (builtins.readDir source));
          {
            inherit source;
            target = ".config/zellij/layouts";
          }
        );
      }
      (if options ? stylix then { stylix.targets.zellij.enable = false; } else { })
    ]
  );
}
