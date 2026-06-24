-- lua/plugins/lsp/extras.lua
--
-- LSP-adjacent utilities that enhance specific workflows.
--
-- lazydev.nvim
--   Dynamically configures lua_ls workspace libraries for Neovim config files.
--   Replaces the static workspace.library approach. Only loads on lua filetypes.
--   Has a blink.cmp integration (see completion.lua for the "lazydev" source).
--   NOTE: do not set workspace.library in after/lsp/lua_ls.lua — lazydev owns it.
--
-- nvim-lsp-file-operations
--   Sends workspace/willRenameFiles and workspace/didRenameFiles LSP notifications
--   when files are moved or renamed. This is what causes ts_ls to update imports.
--   Neovim core has no equivalent — vim.lsp.util.rename renames the file but
--   does not notify the server about imports.
--   Works with: oil.nvim, neo-tree, nvim-tree, triptych.

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    config = true,
  },
}
