{LINE_LENGTH, ...}: {
  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      -- General
      vim.opt.undofile = true           -- persist undo history

      -- Color
      vim.opt.termguicolors = true      -- enable 24-bit color

      -- UI
      vim.opt.number = true             -- show line numbers
      vim.opt.relativenumber = true     -- show relative line numbers
      vim.opt.cursorline = true         -- highlight current line
      vim.opt.colorcolumn = { ${toString LINE_LENGTH.WARNING}, ${toString LINE_LENGTH.MAX} } -- highlight columns
      vim.opt.signcolumn = "yes"        -- always show the sign column
      vim.opt.scrolloff = 8             -- attempt to keep space above/below the cursor

      -- Indentation
      vim.opt.tabstop = 2               -- tab spacing
      vim.opt.softtabstop = 2           -- unify
      vim.opt.shiftwidth = 2            -- indent/outdent by 2 columns
      vim.opt.shiftround = true         -- always indent/outdent to nearest tabstop
      vim.opt.expandtab = true          -- use spaces instead of tabs
      vim.opt.smartindent = true        -- automatically insert one extra level of indentation
      vim.opt.wrap = false              -- don't wrap text

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
    '';
  };
}
