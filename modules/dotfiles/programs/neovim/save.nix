{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins = {
      auto-save.enable = true;
      lsp-format.enable = true;
    };
  };
}
