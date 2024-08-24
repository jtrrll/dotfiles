{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    programs.vscode = {
      userSettings = {
        editor.fontFamily = "Hack Nerd Font Mono";
      };
    };
    stylix.targets.vscode.enable = false;
  };
}
