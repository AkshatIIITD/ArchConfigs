-- lua/plugins/lsp/mason-tools.lua
--
-- mason-tool-installer.nvim
-- Automatically installs formatting and linting binaries.
-- Because mason-lspconfig strictly handles Language Servers, this plugin
-- is required to ensure tools like prettier and eslint_d are installed.

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    priority = 70,
    opts = {
      ensure_installed = {
        -- ── Formatters (from format.lua) ──────────────────────────────
        "stylua", -- Lua
        "prettier", -- Web, JSON, Markdown, YAML
        "goimports", -- Go
        "shfmt", -- Shell/Bash
        "clang-format", -- C/C++

        -- ── Linters (from lint.lua) ───────────────────────────────────
        "eslint_d", -- JS/TS/Vue/Svelte
        "ruff", -- Python (linter and formatter)
        "golangci-lint", -- Go
        "shellcheck", -- Shell/Bash
        "markdownlint", -- Markdown
        "yamllint", -- YAML
        "hadolint", -- Dockerfile linter
      },

      -- Auto-update tools on startup
      auto_update = false,
      -- Run the installer on startup
      run_on_start = true,
    },
  },
}
