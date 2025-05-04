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

        local function apply_arrow_key_remaps(buffer)
          buffer = buffer or 0
          if arrow_key_remap_enabled then
            local opts = { buffer = buffer, silent = true }
            vim.keymap.set('n', 'n', '<Left>', opts)
            vim.keymap.set('n', 'e', '<Down>', opts)
            vim.keymap.set('n', 'i', '<Up>', opts)
            vim.keymap.set('n', 'o', '<Right>', opts)
          else
            pcall(vim.keymap.del, 'n', 'n', { buffer = buffer })
            pcall(vim.keymap.del, 'n', 'e', { buffer = buffer })
            pcall(vim.keymap.del, 'n', 'i', { buffer = buffer })
            pcall(vim.keymap.del, 'n', 'o', { buffer = buffer })
          end
        end

        function snacks.toggle.arrow_key_remap(opts)
          return snacks.toggle.new({
            id = "arrow_key_remap",
            name = "Arrow Key Remap",
            get = function()
              return arrow_key_remap_enabled
            end,
            set = function(state)
              arrow_key_remap_enabled = not not state
              apply_arrow_key_remaps()
            end,
          }, opts)
        end

        vim.api.nvim_create_autocmd("BufEnter", {
          callback = function(args)
            apply_arrow_key_remaps(args.buf)
          end
        })
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
                __unkeyed-1 = "<leader>tc";
                __unkeyed-2.__raw = ''
                  function()
                    require("codecompanion").toggle()
                  end
                '';
                desc = "Chat";
                icon = "󱋊";
              }
              {
                __unkeyed-1 = "<leader>te";
                __unkeyed-2.__raw = ''
                  function()
                    require("snacks").explorer()
                  end
                '';
                desc = "Explorer";
                icon = "󰙅";
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
