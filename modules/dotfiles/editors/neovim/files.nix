{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          settings = {
            explorer.enabled = true;
            picker = {
              enabled = true;
              sources.explorer = {
                auto_close = true;
                hidden = true;
                layout.layout.position = "right";
              };
            };
          };
        };
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
              icon = "󰍉";
            }
            {
              __unkeyed-1 = "<leader>ff";
              __unkeyed-2.__raw = ''
                function()
                  require("snacks").picker.git_files()
                end
              '';
              desc = "File";
              icon = "󰈔";
            }
            {
              __unkeyed-1 = "<leader>ft";
              __unkeyed-2.__raw = ''
                function()
                  require("snacks").picker.git_grep()
                end
              '';
              desc = "Text";
              icon = "󰊄";
            }
            {
              __unkeyed-1 = "<leader>e";
              __unkeyed-2.__raw = ''
                function()
                  require("snacks").explorer()
                end
              '';
              desc = "Explore Files";
              icon = "󰙅";
            }
          ];
        };
      };
    };
  };
}
