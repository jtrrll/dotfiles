{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      keymaps = [
        {
          action = "<cmd>BufferClose<CR>";
          key = "<C-w>";
          mode = "n";
          options = {
            desc = "close tab";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferGoto 1<CR>";
          key = "<C-Up>";
          mode = "n";
          options = {
            desc = "go to the first tab";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferLast<CR>";
          key = "<C-Down>";
          mode = "n";
          options = {
            desc = "go to the last tab";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferNext<CR>";
          key = "<C-Right>";
          mode = "n";
          options = {
            desc = "go to the next tab";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferPrevious<CR>";
          key = "<C-Left>";
          mode = "n";
          options = {
            desc = "go to the previous tab";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferMoveNext<CR>";
          key = "<C-S-Right>";
          mode = "n";
          options = {
            desc = "move the current tab right";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>BufferMovePrevious<CR>";
          key = "<C-S-Left>";
          mode = "n";
          options = {
            desc = "move the current tab left";
            silent = true;
            unique = true;
          };
        }
        {
          action = "<cmd>Neotree toggle<CR>";
          key = "<Tab>";
          mode = "n";
          options = {
            desc = "toggle neotree";
            silent = true;
            unique = true;
          };
        }
      ];
      plugins = {
        barbar = {
          enable = true;
          lazyLoad.settings.event = ["BufAdd"];
          settings.auto_hide = 1; # hides the tabline when only one tab is open
        };
        fzf-lua.enable = true;
        neo-tree = {
          enable = true;
          eventHandlers = {
            file_opened = ''
              function(file_path)
                --auto close
                require("neo-tree").close_all()
              end
            '';
          };
          window.position = "right";
        };
        which-key.settings.spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "files";
            icon = "󰈔";
          }
          {
            __unkeyed-1 = "<leader>ff";
            __unkeyed-2 = "<cmd>FzfLua files<CR>";
            desc = "fuzzy-find a file";
            icon = "󰱼";
          }
          {
            __unkeyed-1 = "<leader>ft";
            __unkeyed-2 = "<cmd>Neotree toggle<CR>";
            desc = "toggle file tree";
            icon = "󰙅";
          }
        ];
      };
    };
  };
}
