{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = "  ";
      };
      plugins = {
        which-key = {
          enable = true;
          settings = {
            keys = {
              scroll-down = "<Down>";
              scroll-up = "<Up>";
            };
            preset = "modern";
          };
        };
      };
    };
  };
}
