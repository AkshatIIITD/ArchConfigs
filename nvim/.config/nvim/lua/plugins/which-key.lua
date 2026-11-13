return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>c", group = "code" },
      { "<leader>w", group = "windows" },
      { "<leader>t", group = "toggle" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "hunks" },
      { "<leader>x", group = "trouble" },
      { "<leader>i", group = "ai" },
    },
  },
}
