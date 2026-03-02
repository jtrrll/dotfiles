_:
{
  config = {
    programs.nixvim.plugins = {
      auto-save = {
        enable = true;
        lazyLoad.settings.event = [ "BufLeave" ];
      };
      lsp-format.enable = true;
    };
  };
}
