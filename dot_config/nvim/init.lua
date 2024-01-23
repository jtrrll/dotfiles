-- Color
vim.opt.termguicolors = true

-- UI
vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.cursorline = true     -- highlight current line

-- Indentation
vim.opt.tabstop = 2           -- tab spacing
vim.opt.softtabstop = 2       -- unify
vim.opt.shiftwidth = 2        -- indent/outdent by 2 columns
vim.opt.shiftround = true     -- always indent/outdent to nearest tabstop
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true    -- automatically insert one extra level of indentation
vim.opt.wrap = false          -- don't wrap text

-- Input
local cursorRefreshGroup = vim.api.nvim_create_augroup("cursorRefresh", {}) -- switch between block and beam cursor shapes
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
