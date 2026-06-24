-- lua/plugins/lsp/mason-tools.lua
--
-- mason-tool-installer.nvim
-- Automatically installs formatting and linting binaries.
-- Because mason-lspconfig strictly handles Language Servers, this plugin
-- is required to ensure tools like prettierd and eslint_d are installed.

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    priority = 70,
    opts = {
      ensure_installed = {
        -- ── Formatters (from conform.lua) ─────────────────────────────
        "stylua", -- Lua
        "prettierd", -- Web, JSON, Markdown, YAML
        "prettier", -- Web (Fallback)
        "isort", -- Python imports
        "black", -- Python
        "goimports", -- Go
        "shfmt", -- Shell/Bash
        "clang-format", -- C/C++

        -- ── Linters (from lint.lua) ───────────────────────────────────
        "eslint_d", -- JS/TS/Vue/Svelte
        "ruff", -- Python
        "golangci-lint", -- Go
        "shellcheck", -- Shell/Bash
        "markdownlint", -- Markdown
        "yamllint", -- YAML
      },

      -- Auto-update tools on startup
      auto_update = false,
      -- Run the installer on startup
      run_on_start = true,
    },
  },
}
