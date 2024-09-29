{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins = {
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
        };
      };
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
        settings = {
          max_lines = 2;
        };
      };
    };
  };
}
