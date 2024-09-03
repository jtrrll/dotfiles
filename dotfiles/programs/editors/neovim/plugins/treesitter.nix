{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.dotfiles.programs.enable && elem "neovim" config.dotfiles.programs.editors) {
    programs.nixvim.plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
            additional_vim_regex_highlighting = ["ruby"];
          };
          indent = {
            enable = true;
            disable = ["ruby"];
          };
        };
      };
      treesitter-context = {
        enable = true;
        settings = {max_lines = 2;};
      };
    };
  };
}
