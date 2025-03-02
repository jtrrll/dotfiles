{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins.snacks = {
      enable = true;
      settings.dashboard = {
        enabled = true;
        preset.keys = [
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action.__raw = ''
              function()
                require("snacks").picker.git_files()
              end
            '';
          }
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent Files";
            action.__raw = ''
              function()
                require("snacks").picker.recent()
              end
            '';
          }
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
        ];
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
    };
  };
}
