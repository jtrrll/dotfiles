{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    programs.vscode.userSettings = {
      editor.fontFamily = "Hack Nerd Font Mono";
    };
    stylix.targets.vscode.enable = false;
  };
}
