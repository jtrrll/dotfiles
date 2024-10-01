{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
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
        window.position = "right";
      };
    };
  };
}
