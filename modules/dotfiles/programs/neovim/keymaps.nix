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
      keymaps = [
        {
          action = "<cmd>Neotree toggle<CR>";
          key = "<Tab>";
          mode = "n";
          options = {
            desc = "toggle neotree";
            nowait = true;
            silent = true;
            unique = true;
          };
        }
        {
          action = "h";
          key = "<C-m>";
          mode = "n";
          options = {
            desc = "move cursor left";
            nowait = true;
            silent = true;
            unique = true;
          };
        }
        {
          action = "j";
          key = "<C-n>";
          mode = "n";
          options = {
            desc = "move cursor down";
            nowait = true;
            silent = true;
            unique = true;
          };
        }
        {
          action = "k";
          key = "<C-e>";
          mode = "n";
          options = {
            desc = "move cursor up";
            nowait = true;
            silent = true;
            unique = true;
          };
        }
        {
          action = "l";
          key = "<C-i>";
          mode = "n";
          options = {
            desc = "move cursor right";
            nowait = true;
            silent = true;
            unique = true;
          };
        }
      ];
    };
  };
}
