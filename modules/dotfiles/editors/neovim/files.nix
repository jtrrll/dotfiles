{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      keymaps = [
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
