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
        lazyLoad.settings.event = ["BufLeave"];
      };
    };
  };
}
