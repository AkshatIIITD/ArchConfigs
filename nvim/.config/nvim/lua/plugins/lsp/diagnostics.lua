-- lua/plugins/lsp/diagnostics.lua
-- Renders diagnostics inline. The vim.diagnostic.config() settings live in
-- lua/config/diagnostics.lua so they apply from startup.
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      preset = "modern",
      options = {
        show_source = { enabled = true, if_many = true },
        multilines = { enabled = true, always_show = false },
        multiple_diag_under_cursor = true,
        show_all_diags_on_cursorline = false,
        overflow = { mode = "wrap" },
      },
    },
  },
}