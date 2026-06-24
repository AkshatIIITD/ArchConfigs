-- lua/plugins/git/diffview.lua

return {
  "dlyongemallo/diffview.nvim",
  version = "*",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
    "DiffviewDiffFiles",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
    { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
    { "<leader>gf", "<cmd>DiffviewToggleFiles<CR>", desc = "Toggle Diff File Panel" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "File History (Current)" },
    { "<leader>gB", "<cmd>DiffviewFileHistory<CR>", desc = "Branch History (All)" },
  },
  opts = {
    hooks = {
      view_opened = function()
        -- Auto-close the file tree to save horizontal screen space
        vim.cmd("DiffviewToggleFiles")
      end,
    },
  },
}
