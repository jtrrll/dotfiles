{
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.neovim = {
      enable = true;
      withPython3 = false;
      withRuby = false;
    };
    home.sessionVariables.EDITOR = lib.getExe pkgs.neovim;
  };
}
