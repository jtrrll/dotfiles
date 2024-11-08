{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins = {
      auto-save.enable = true;
      lsp-format.enable = true;
    };
  };
}
