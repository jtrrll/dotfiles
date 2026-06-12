{
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.neovim.enable = true;
    home.sessionVariables.EDITOR = lib.getExe pkgs.neovim;
  };
}
