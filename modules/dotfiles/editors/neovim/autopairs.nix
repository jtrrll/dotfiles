{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins.nvim-autopairs.enable = true;
  };
}
