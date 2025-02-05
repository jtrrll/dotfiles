{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.plugins = {
      auto-save = {
        enable = true;
        lazyLoad.settings.event = ["BufLeave"];
      };
      lsp-format = {
        enable = true;
        # TODO: This needs to be loaded before LSP somehow
        # lazyLoad.settings.event = ["BufLeave"];
      };
    };
  };
}
