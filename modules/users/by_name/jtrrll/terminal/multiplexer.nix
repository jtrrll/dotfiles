{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.zellij.enable = lib.mkDefault true;
    }
    (lib.mkIf config.programs.zellij.enable {
      home.packages = [ pkgs.watch ];
      programs.zellij.plugins = [
        pkgs.zellij-agent-handler
      ];
      programs.zellij.settings = {
        show_release_notes = false;
        show_startup_tips = false;
        ui.pane_frames.rounded_corners = true;
      };
    })
  ];
}
