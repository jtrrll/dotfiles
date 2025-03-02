{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      extraConfigLua = ''
        local snacks = require("snacks")
        local arrow_key_remap_enabled = false

        ---@param opts? snacks.toggle.Config
        function snacks.toggle.arrow_key_remap(opts)
          return snacks.toggle.new({
            id = "arrow_key_remap",
            name = "Arrow Key Remap",
            get = function()
              return arrow_key_remap_enabled
            end,
            set = function(state)
              arrow_key_remap_enabled = state or false

              if arrow_key_remap_enabled then
                vim.keymap.set('n', 'n', '<Left>')
                vim.keymap.set('n', 'e', '<Down>')
                vim.keymap.set('n', 'i', '<Up>')
                vim.keymap.set('n', 'o', '<Right>')
              else
                vim.keymap.del('n', 'n')
                vim.keymap.del('n', 'e')
                vim.keymap.del('n', 'i')
                vim.keymap.del('n', 'o')
              end
            end,
          }, opts)
        end
      '';
      globals = {
        mapleader = " ";
        maplocalleader = "  ";
      };
      plugins = {
        snacks = {
          enable = true;
          settings.toggle.enabled = true;
        };
        which-key = {
          enable = true;
          settings = {
            keys = {
              scroll-down = "<Down>";
              scroll-up = "<Up>";
            };
            preset = "modern";
            spec = [
              {
                __unkeyed-1 = "<leader>t";
                group = "Toggle";
                icon = "";
              }
              {
                __unkeyed-1 = "<leader>tn";
                __unkeyed-2.__raw = ''
                  function()
                    require("snacks").toggle.arrow_key_remap():toggle()
                  end
                '';
                desc = "Navigation";
                icon = "󱣱";
              }
            ];
          };
        };
      };
    };
  };
}
