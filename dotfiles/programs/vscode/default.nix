{
  config,
  constants,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = {
        editor = {
          minimap.enabled = false;
          tabSize = constants.INDENT_WIDTH;
          rulers = [constants.LINE_LENGTH.WARNING constants.LINE_LENGTH.MAX];
        };
        nix = {
          enableLanguageServer = true;
          serverPath = "nil";
        };
        redhat.telemetry.enabled = false;
        window.zoomLevel = 2;
        workbench.sideBar.location = "right";
      };
    };
  };

  imports = [
    ./extensions.nix
  ];

  options = {
    dotfiles.programs.vscode = {
      enable = lib.mkEnableOption "VSCode";
    };
  };
}
