{
  imports = [
    ./plugins

    ./aliases.nix
    ./keymaps.nix
    ./opts.nix
  ];
  programs.nixvim = {
    enable = true;
    colorschemes.vscode.enable = true;
    extraConfigLua = ''
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
}
