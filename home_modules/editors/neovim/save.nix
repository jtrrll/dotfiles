{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.editors.neovim.enable {
    programs.nixvim.plugins = {
      auto-save = {
        enable = true;
        lazyLoad.settings.event = [ "BufLeave" ];
      };
      lsp-format.enable = true;
    };
  };
}
