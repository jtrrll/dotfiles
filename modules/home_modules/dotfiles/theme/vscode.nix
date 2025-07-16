{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.vscode.profiles.default.userSettings = {
      editor.fontFamily = "Hack Nerd Font Mono";
      workbench.colorTheme = "Default Dark Modern";
    };
    stylix.targets.vscode.enable = false;
  };
}
