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
      { "<leader>i", group = "ai" },
    },
  },
}
