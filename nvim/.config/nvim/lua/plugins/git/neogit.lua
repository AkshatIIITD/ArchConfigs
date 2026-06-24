-- lua/plugins/git/neogit.lua

return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "dlyongemallo/diffview.nvim",
    -- uncomment whichever picker you use:
    "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    -- "folke/snacks.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    -- { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
    -- { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Neogit push" },
    -- { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Neogit pull" },
  },
  opts = {
    integrations = {
      diffview = true,
    },
    kind = "tab",
  },
}
