vim.g.mapleader = " " -- leader key (must be set before lazy loads)
vim.g.maplocalleader = "\\"

-- ========================================================================== --
-- OPTIONS                                                                    --
-- ========================================================================== --
vim.o.number = true -- line number
vim.o.relativenumber = true -- relative line number
vim.o.wrap = false -- do not wrap lines by default
vim.o.cursorline = true -- highlight current line
vim.o.scrolloff = 999 -- keep cursor in the middle
vim.o.sidescrolloff = 15 -- keep 15 columns to left/right of cursor

vim.o.mouse = "a" -- enable mouse

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

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
vim.o.splitkeep = "screen" -- stop text jumping when splits open/close
vim.o.winborder = "rounded" -- border on all floating windows (0.11+)

-- Responsiveness
vim.o.updatetime = 250 -- CursorHold delay (LSP document highlight etc.)
vim.o.timeoutlen = 400 -- wait time for multi-key mappings

-- Persistence / safety
vim.o.undofile = true -- undo survives closing the file
vim.o.confirm = true -- ask instead of erroring on :q with unsaved changes

-- Folding (treesitter by default; attach.lua overrides with LSP when available)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99 -- start with everything open

-- vim.opt.clipboard = "unnamedplus" -- Natively syncs Neovim clipboard with system clipboard