-- lua/plugins/format.lua
--
-- ─── WHY conform.nvim ────────────────────────────────────────────────────────
--
-- The only serious formatting plugin in 2026. null-ls is archived, none-ls is
-- a community fork with unclear maintenance. conform.nvim is actively maintained
-- by stevearc (same author as oil.nvim).
--
-- ─── DEPRECATED API — DO NOT USE ─────────────────────────────────────────────
--
-- OLD (dead since 2025-01-01):
--   javascript = { { "prettierd", "prettier" } }   ← nested {} syntax, gone
--   lsp_fallback = true                             ← boolean form, gone
--
-- CURRENT:
--   javascript = { "prettierd", "prettier", stop_after_first = true }
--   lsp_format = "fallback"                         ← string enum
--
-- lsp_format values:
--   "never"    → never use LSP formatting
--   "first"    → use LSP before formatters
--   "last"     → use LSP after formatters
--   "prefer"   → use LSP, skip external formatters
--   "fallback" → use LSP only when no formatter matches the filetype ✓ use this
--
-- ─── stop_after_first ────────────────────────────────────────────────────────
--
-- When multiple formatters are listed, conform tries them left to right and
-- runs ALL of them in sequence by default (e.g. isort then black for Python).
-- stop_after_first = true changes that: run only the FIRST one that is installed.
-- Use it when formatters are alternatives (prettierd OR prettier), not a chain.
--
-- ─── FORMAT ON SAVE — function vs table ──────────────────────────────────────
--
-- Table form (simple):
--   format_on_save = { timeout_ms = 500, lsp_format = "fallback" }
--   Formats every buffer on every save. No conditions.
--
-- Function form (recommended):
--   format_on_save = function(bufnr) ... return { ... } end
--   Return nil to skip formatting for that buffer. This is how you disable
--   formatting for specific filetypes, large files, or via a toggle variable.
--
-- ─── SYSTEM REQUIREMENTS ─────────────────────────────────────────────────────
-- Formatters are external binaries. Install via mason-tool-installer or manually.
-- mason.nvim installs to ~/.local/share/nvim/mason/bin/ (auto on PATH).
--
-- Quick check if a formatter is available:
--   :ConformInfo

return {
  {
    "stevearc/conform.nvim",
    -- Load on BufWritePre so it's ready before the first save.
    -- Also load the :ConformInfo command on demand.
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format file / selection",
      },

      -- Toggle format-on-save for the current session.
      -- Does not persist across restarts — just a quick escape hatch.
      {
        "<leader>tf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save: " .. (vim.g.disable_autoformat and "disabled" or "enabled"), vim.log.levels.INFO)
        end,
        desc = "Toggle format on save",
      },
    },

    opts = {
      -- ── Formatters by filetype ─────────────────────────────────────────────
      --
      -- Multiple formatters with NO stop_after_first → run in sequence (a pipeline).
      -- Example: python = { "isort", "black" } → isort first, then black.
      --
      -- Multiple formatters WITH stop_after_first = true → use first available.
      -- Example: javascript = { "prettierd", "prettier", stop_after_first = true }
      -- Try prettierd (faster daemon), fall back to prettier if not installed.
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- JavaScript / TypeScript
        -- prettierd is a long-running daemon — faster after first run.
        -- Falls back to prettier if prettierd is not installed.
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },

        -- Web
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },

        -- Data formats
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },

        -- Markdown
        markdown = { "prettierd", "prettier", stop_after_first = true },

        -- Python
        -- Pipeline: isort sorts imports first, black formats everything else.
        -- These are complementary, not alternatives — no stop_after_first.
        python = { "isort", "black" },

        -- Go
        -- goimports = gofmt + import organisation. Single tool, no chain needed.
        go = { "goimports" },

        -- Rust
        -- rustfmt ships with the Rust toolchain, not a mason package.
        rust = { "rustfmt" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- C / C++
        c = { "clang_format" },
        cpp = { "clang_format" },

        -- Fallback: for any filetype with no formatter listed, trim trailing
        -- whitespace. Does not conflict with lsp_format = "fallback".
        ["_"] = { "trim_whitespace" },
      },

      -- ── Default format options ─────────────────────────────────────────────
      -- Applied to every conform.format() call unless overridden per-call.
      default_format_opts = {
        lsp_format = "fallback", -- use LSP if no conform formatter matches
      },

      -- Set this to true to allow conform to handle the gq formatting motion
      -- instead of Neovim's internal formatting engine.
      format_expr = true,

      -- ── Format on save ─────────────────────────────────────────────────────
      -- Function form: return nil to skip, return opts table to format.
      format_on_save = function(bufnr)
        -- Global toggle: set via <leader>tf keymap above
        if vim.g.disable_autoformat then
          return
        end

        -- Buffer-local toggle: set with :lua vim.b.disable_autoformat = true
        if vim.b[bufnr].disable_autoformat then
          return
        end

        -- Skip files larger than 1MB — formatting large files blocks the UI
        local max_size = 1024 * 1024
        local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stat and stat.size > max_size then
          return
        end

        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,

      -- ── Formatter overrides ────────────────────────────────────────────────
      -- Override individual formatter behaviour. Only set what differs from
      -- the formatter's own defaults or your project's config file.
      formatters = {
        -- stylua: use spaces + 2-width by default.
        -- Overridden per-project by .stylua.toml if present.
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },

        -- shfmt: 2-space indentation for shell scripts
        shfmt = {
          prepend_args = { "-i", "2" },
        },

        -- isort: use black-compatible profile to avoid conflicts
        isort = {
          prepend_args = { "--profile", "black" },
        },
      },
    },
  },
}
