{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.theme.enable {
    programs.nixvim.colorschemes.vscode.enable = true;
    stylix.targets.nixvim.enable = false;
  };
}
