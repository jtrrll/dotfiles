{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.programs.enable && elem "neovim" config.dotfiles.programs.editors) {
    programs.nixvim.globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
