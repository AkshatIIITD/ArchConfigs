-- lua/plugins/lsp/servers.lua
--
-- Two plugins. One concern: getting LSP servers installed and enabled.
--
-- neovim/nvim-lspconfig
--   Passive data provider only. Puts lsp/*.lua files onto runtimepath.
--   Each file has: cmd, filetypes, root_markers for one server.
--   Neovim reads them automatically — you never call require('lspconfig').
--   require('lspconfig').X.setup() is DEPRECATED and will become an error.
--
-- mason-org/mason-lspconfig.nvim
--   Translates lspconfig names (lua_ls) to mason package names (lua-language-server).
--   Calls vim.lsp.enable() automatically for every installed server.
--   automatic_enable = true is the default. handlers and automatic_installation
--   were removed in v2.

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 90,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    priority = 80,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- Web
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "graphql",

        -- Systems
        "rust_analyzer",
        "clangd",

        -- Config / scripting
        "lua_ls",
        "bashls",

        -- Data formats
        "jsonls",
        "yamlls",
        "marksman",

        -- Python and Go
        "basedpyright",
        "gopls",

        -- Java
        "jdtls",
      },

      -- Calls vim.lsp.enable() for every installed server automatically.
      -- To exclude a server managed by another plugin (e.g. rustaceanvim):
      --   automatic_enable = { exclude = { "rust_analyzer" } }
      automatic_enable = {
        exclude = {
          "jdtls",
        },
      },
    },
  },
}
