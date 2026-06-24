vim.g.mapleader = " " -- leader key

-- ========================================================================== --
-- OPTIONS                                                                    --
-- ========================================================================== --
vim.o.number = true -- line number
vim.o.relativenumber = true -- relative line number
vim.o.wrap = false -- do not wrap lines by default
vim.o.cursorline = true -- highlight current line
vim.o.scrolloff = 999 -- keep cursor middle
vim.o.sidescrolloff = 15 -- keep 10 lines to left/right of cursor

vim.o.mouse = "a" -- enable mouse

vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + {
  space = "·",
  trail = "·",
}

vim.o.tabstop = 4 -- tabwidth
vim.o.shiftwidth = 4 -- indent width
vim.o.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.smartindent = true -- smart auto-indent
vim.o.autoindent = true -- copy indent from current line

-- Search Behavior
vim.o.ignorecase = true -- case insensitive search
vim.o.smartcase = true -- case sensitive if uppercase in string

-- UI & Windows
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.opt.clipboard = "unnamedplus" -- Natively syncs Neovim clipboard with system clipboard
