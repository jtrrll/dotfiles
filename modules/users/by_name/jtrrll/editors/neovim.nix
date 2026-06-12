{
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.nixvim = {
      enable = true;
      package = pkgs.neovim;
    };
    home.sessionVariables.EDITOR = lib.getExe pkgs.neovim;
  };
}
