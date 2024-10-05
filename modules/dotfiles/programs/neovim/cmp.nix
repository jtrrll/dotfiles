{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.neovim.enable {
    programs.nixvim.plugins = {
      cmp = {
        enable = true;
        settings = {
          completion = {
            completeopt = "menu,menuone,noinsert";
          };
          experimental = {
            ghost_text = {hl_group = "NonText";};
          };
          mapping = {
            "<C-e>" = "cmp.mapping.close()";
            "<S-Tab>" = "cmp.mapping.select_next_item()";
            "<Tab>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            {name = "nvim_lsp";}
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
    };
  };
}
