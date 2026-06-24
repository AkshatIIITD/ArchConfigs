return {
  "kevinhwang91/nvim-bqf",
  ft = "qf", -- Only loads when you open a quickfix window
  opts = {
    preview = {
      auto = true,
      show_title = true,
      delay_syntax = 50,
      wrap = false,
    },
  },
}
