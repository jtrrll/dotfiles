{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.nixvim.plugins = {
      cmp = {
        enable = true;
        settings = {
          experimental = {
            ghost_text = {hl_group = "NonText";};
          };
          sources = [
            {name = "nvim_lsp";}
          ];
        };
      };
      cmp-nvim-lsp = {
        enable = true;
      };
    };
  };
}
