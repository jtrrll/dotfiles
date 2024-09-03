{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    ./plugins

    ./aliases.nix
    ./keymaps.nix
    ./opts.nix
  ];
  config = mkIf (config.dotfiles.programs.enable && elem "neovim" config.dotfiles.programs.editors) {
    programs.nixvim = {
      enable = true;
      extraConfigLua = ''
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

        -- Input
        -- switch between block and beam cursor shapes
        local cursorRefreshGroup = vim.api.nvim_create_augroup("cursorRefresh", {})
        vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "CmdlineLeave"},
          {
            pattern = "*",
            callback = function() vim.opt.guicursor = "a:block" end,
            group = cursorRefreshGroup
          })
        vim.api.nvim_create_autocmd({"VimLeave", "InsertEnter", "CmdlineEnter"},
          {
            pattern = "*",
            callback = function() vim.opt.guicursor = "a:ver25" end,
            group = cursorRefreshGroup
          })

        vim.api.nvim_create_autocmd('TextYankPost', {
          desc = 'Highlight when yanking text',
          group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
          callback = function()
            vim.highlight.on_yank()
          end
        })
      '';
    };
  };
}
