-- lua/plugins/lsp/diagnostics.lua
--
-- Diagnostic display configuration.
-- tiny-inline-diagnostic replaces Neovim's default virtual_text rendering.
-- It overlays messages inline without shifting any lines.

return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "modern",
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        multilines = {
          enabled = true,
          always_show = false,
        },
        multiple_diag_under_cursor = true,
        show_all_diags_on_cursorline = false,
        overflow = { mode = "wrap" },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      -- Disable default virtual_text — tiny-inline-diagnostic owns this now.
      -- This must come after setup(), not before.
      vim.diagnostic.config({ virtual_text = false, signs = false })
    end,
  },
}
