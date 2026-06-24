-- ========================================================================== --
-- KEYMAPS                                                                    --
-- ========================================================================== --

-- ─── WINDOW MANAGEMENT ────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>wh", "<cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close current window" })

-- Move Lines Up/Down (Ctrl + Alt + j/k)
vim.keymap.set("n", "<C-A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("x", "<C-A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("x", "<C-A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- ─── TAB MANAGEMENT ───────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader><tab>", "<cmd>tabnew<CR>", { desc = "Create new tab" })

-- ─── Window Movement ───────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Loop to create Alt+1 through Alt+9 keymaps for tab navigation
for i = 1, 9 do
  vim.keymap.set("n", "<M-" .. i .. ">", i .. "gt", { desc = "Go to tab " .. i })
end

-- ─── CLEAR SCREEN / HIGHLIGHTS ────────────────────────────────────────────────
vim.keymap.set(
  "n",
  "<C-A-L>",
  "<cmd>nohlsearch<CR><cmd>diffupdate<CR><cmd>normal! <C-l><CR>",
  { desc = "Clear screen and search highlights" }
)
-- copy & paste
vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y', { silent = true }) -- Copy to system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>p", '"+p', { silent = true }) -- Paste from system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>d", '"+d', { silent = true }) -- Copy to system clipboard in normal/visual mode

-- Normal mode: <leader>/ triggers gcc (Line comment)
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })

-- Visual mode: <leader>/ triggers gc (Selection comment)
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Command-line menu navigation (C-j,k overridden by blink.nvim)
-- vim.keymap.set("c", "<C-j>", "<C-n>", { desc = "Command line next item/history" })
-- vim.keymap.set("c", "<C-k>", "<C-p>", { desc = "Command line prev item/history" })

-- ─── NATIVE QUICKFIX TOGGLE ───────────────────────────────────────────────────
vim.keymap.set("n", "<leader>q", function()
  -- Ask Neovim for the window ID of the quickfix list in the current tab
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid

  if qf_winid ~= 0 then
    -- If the ID is not 0, the window is open. Close it.
    vim.cmd("cclose")
  else
    -- If it is 0, the window is closed.
    -- Check if it actually has items inside it before opening.
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd("copen")
    else
      vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    end
  end
end, { desc = "Toggle Native Quickfix" })
