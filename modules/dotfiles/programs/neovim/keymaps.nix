{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
    };
  };
}
