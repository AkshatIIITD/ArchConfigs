-- lua/plugins/todo-comments.lua

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    -- ] / [ navigation — consistent with ]h/[h (hunks), ]d/[d (diagnostics)
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Todo: next",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Todo: prev",
    },
    -- Filter to only actionable items (things you actually need to do)
    {
      "]T",
      function()
        require("todo-comments").jump_next({ keywords = { "TODO", "FIX" } })
      end,
      desc = "Todo: next TODO/FIX",
    },
    {
      "[T",
      function()
        require("todo-comments").jump_prev({ keywords = { "TODO", "FIX" } })
      end,
      desc = "Todo: prev TODO/FIX",
    },

    { "<leader>tq", "<cmd>TodoQuickFix<CR>", desc = "Todo: all (telescope)" },
    { "<leader>Tq", "<cmd>TodoQuickFix keywords=TODO,FIX<CR>", desc = "Todo: TODO/FIX (telescope)" },
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    signs = false,
  },
}
