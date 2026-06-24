-- lua/plugins/trouble.lua

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "Trouble",
  keys = {
    -- workspace diagnostics
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    -- buffer diagnostics only
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    -- document symbols
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    -- -- LSP definitions, references, implementations
    -- {
    --   "<leader>cl",
    --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --   desc = "LSP (Trouble)",
    -- },
    -- location list
    -- {
    --   "<leader>xL",
    --   "<cmd>Trouble loclist toggle<cr>",
    --   desc = "Location List (Trouble)",
    -- },
    -- quickfix list
    -- {
    --   "<leader>xQ",
    --   "<cmd>Trouble qflist toggle<cr>",
    --   desc = "Quickfix List (Trouble)",
    -- },
  },
  opts = {},
}
