{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.dotfiles.theme.enable && config.dotfiles.theme.classicCode) {
    programs.nixvim.colorschemes.vscode.enable = true;
    stylix.targets.nixvim.enable = false;
  };
}
