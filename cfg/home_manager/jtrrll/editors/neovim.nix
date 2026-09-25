{
  lib,
  pkgs,
  ...
}:
{
  config.home = {
    packages = [ pkgs.neovim ];
    sessionVariables.EDITOR = lib.getExe pkgs.neovim;
  };
}
