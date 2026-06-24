-- lua/plugins/lsp/schemastore.lua
--
-- b0o/SchemaStore.nvim — JSON/YAML schema catalog
-- Extends jsonls and yamlls configs using the 0.11+ vim.lsp.config() API.
-- Must be lazy = false so vim.lsp.config() calls run before any server attaches.

return {
  {
    "b0o/SchemaStore.nvim",
    lazy = false, -- tiny data plugin, no perf cost — must run before servers attach
    version = false, -- last git tag is too old, track main
    config = function()
      -- ── jsonls ─────────────────────────────────────────────────────────────
      -- before_init runs just before the client initialises, so schemastore
      -- is guaranteed to be loaded by then.
      vim.lsp.config("jsonls", {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.json = config.settings.json or {}
          config.settings.json.schemas = require("schemastore").json.schemas()
        end,
        settings = {
          json = {
            validate = { enable = true },
            format = { enable = true },
          },
        },
      })

      -- ── yamlls ─────────────────────────────────────────────────────────────
      -- schemaStore.enable = false is REQUIRED — disables yamlls's own built-in
      -- catalog so it doesn't conflict with SchemaStore.nvim.
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            keyOrdering = false,
            validate = true,
            format = { enable = true },
            schemaStore = {
              enable = false, -- must be disabled
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
          redhat = { telemetry = { enabled = false } },
        },
      })
    end,
  },
}
