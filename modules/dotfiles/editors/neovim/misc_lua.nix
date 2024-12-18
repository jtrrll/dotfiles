{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.editors.enable {
    programs.nixvim.extraConfigLua = ''
      -- UI
      -- Define a border style
      local border = {
        {"╭", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╮", "FloatBorder"},
        {"│", "FloatBorder"},
        {"╯", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╰", "FloatBorder"},
        {"│", "FloatBorder"},
      }

      -- Customize the LSP hover handler
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })  -- Use the same background as the editor
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })  -- Use the same background as the editor
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = border
        }
      )
    '';
  };
}
