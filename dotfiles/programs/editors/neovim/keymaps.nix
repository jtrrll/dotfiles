{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.nixvim.globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
