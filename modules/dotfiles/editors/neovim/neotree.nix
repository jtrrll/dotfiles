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
            nowait = true;
            silent = true;
            unique = true;
          };
        }
      ];
      plugins.neo-tree = {
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
    };
  };
}
