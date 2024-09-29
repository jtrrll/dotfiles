{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins.nvim-autopairs = {
      enable = true;
    };
  };
}
