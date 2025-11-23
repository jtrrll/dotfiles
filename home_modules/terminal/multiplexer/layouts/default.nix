{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.terminal.enable {
    programs.zellij.layouts =
      let
        default_tab_template = {
          _children = [
            {
              pane = {
                size = 1;
                borderless = true;
                plugin.location = "zellij:tab-bar";
              };
            }
            { children = { }; }
            {
              pane = {
                size = 2;
                borderless = true;
                plugin.location = "zellij:status-bar";
              };
            }
          ];
        };
      in
      {
        default.layout._children = [
          { inherit default_tab_template; }
        ];
        editor = import ./editor.nix {
          inherit default_tab_template;
          claude = lib.getExe config.programs.claude-code.package;
          neovim = lib.getExe config.programs.nixvim.finalPackage;
        };
      };
  };
}
