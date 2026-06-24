-- lua/plugins/lint.lua
--
-- ─── WHY nvim-lint ────────────────────────────────────────────────────────────
--
-- Runs external linter binaries and feeds results into vim.diagnostic.
-- Complementary to LSP — not a replacement. Both show in vim.diagnostic.
-- tiny-inline-diagnostic renders all of them the same way.
--
-- LSP diagnostics   → type errors, undefined symbols, semantic analysis
-- nvim-lint         → style rules, code quality, opinionated checks
--
-- ─── LINTER RECOMMENDATIONS (2026, fact-checked) ─────────────────────────────
--
-- JavaScript / TypeScript:
--   eslint_d        → ESLint as a daemon. Fast after first run. The standard.
--                     ESLint v9 flat config (eslint.config.js) is current;
--                     .eslintrc is officially deprecated but still works.
--   oxlint          → 50-100x faster, 500+ rules. Better used via LSP
--                     (nvim-lspconfig has oxlint.lua). Not in this file.
--
-- Python:
--   ruff            → Replaces flake8 + isort + pyupgrade in one binary.
--                     10-100x faster than flake8. The clear winner for 2026.
--                     Auto-discovers pyproject.toml or ruff.toml.
--
-- Go:
--   golangci-lint   → Parallel Go linter runner. Requires a saved file (no
--                     stdin support). Guarded: only runs when a golangci
--                     config file is present — without config it runs all
--                     default linters which is very slow.
--
-- Shell:
--   shellcheck      → The standard. No real alternative.
--
-- Markdown:
--   markdownlint    → Style and structure checks. Reads .markdownlint.json.
--
-- YAML:
--   yamllint        → Structure, indentation, style checks. Reads .yamllint.
--
-- ─── SPECIAL linters_by_ft KEYS ──────────────────────────────────────────────
--
-- nvim-lint supports three kinds of keys in linters_by_ft:
--
--   "ft"   → runs only on buffers with that specific filetype (standard)
--   "*"    → runs on EVERY filetype, always appended to the ft list
--   "_"    → runs as FALLBACK when no ft-specific linters are configured
--
-- Our trigger_lint() collects all three correctly:
--   names  = linters_by_ft[ft]  or {}     (filetype-specific)
--   if #names == 0: also add linters_by_ft["_"] or {}  (fallback)
--   always add:     linters_by_ft["*"]  or {}           (global)
--
-- ─── TRIGGER EVENTS ──────────────────────────────────────────────────────────
--
-- BufWritePost → lint on save. Works for all linters.
-- BufReadPost  → lint when opening an existing file.
-- BufNewFile   → lint when creating a new file (before first save).
-- InsertLeave  → lint after leaving insert mode (stdin-supporting linters only).
--
-- IMPORTANT: the lazy `event` list must be a superset of the autocmd events.
-- If InsertLeave is in the autocmd but not in `event`, the plugin won't be
-- loaded yet when InsertLeave fires on a new unsaved file — linting silently
-- doesn't happen. Both lists must match.
--
-- ─── DESIGN: PER-LINTER GUARDS ───────────────────────────────────────────────
--
-- Guards are mapped to LINTER NAMES, not filetypes.
-- If javascript = { "eslint_d", "cspell" } and the eslint guard fails,
-- only eslint_d is skipped — cspell still runs.
-- A filetype-level guard would have killed all linters for that ft.
--
-- Flow per linter in the collected list:
--   1. Check if linter has a guard in linter_guards
--   2. If yes: run vim.fs.root(bufnr, patterns) — skip if nil
--   3. If no guard: always include
--   4. Pass surviving list to try_lint()
--
-- ─── EXTENDING THIS CONFIG ────────────────────────────────────────────────────
--
-- Add a new filetype linter:
--   → add to linters_by_ft
--   → add guard to linter_guards if it needs a config file check
--
-- Add a global linter (runs on every file):
--   → add to linters_by_ft["*"] = { "typos" }
--
-- Add a fallback linter (runs when no ft linter is configured):
--   → add to linters_by_ft["_"] = { "typos" }
--
-- Disable linting for a buffer:   :lua vim.b.disable_lint = true
-- Disable linting for session:    :lua vim.g.disable_lint = true

-- The lazy event list and autocmd event list must stay in sync.
-- Define once, use in both places.
local LINT_EVENTS = { "BufReadPost", "BufWritePost", "BufNewFile", "InsertLeave" }

return {
  {
    "mfussenegger/nvim-lint",
    event = LINT_EVENTS, -- must be superset of autocmd events below

    keys = {
      {
        "<leader>cl",
        function()
          require("lint").try_lint()
        end,
        desc = "Lint current buffer",
      },
      {
        "<leader>tl",
        function()
          vim.b.disable_lint = not vim.b.disable_lint
          vim.notify("Lint: " .. (vim.b.disable_lint and "disabled" or "enabled") .. " (buffer)", vim.log.levels.INFO)
        end,
        desc = "Toggle lint (buffer)",
      },
    },

    config = function()
      local lint = require("lint")

      -- ── Linters by filetype ───────────────────────────────────────────────
      -- Standard ft keys: run only for that filetype.
      -- "*" key: appended to every filetype's linter list.
      -- "_" key: used when no ft-specific linter is found.
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },

        python = { "ruff" },

        go = { "golangci-lint" },

        sh = { "shellcheck" },
        bash = { "shellcheck" },

        markdown = { "markdownlint" },

        yaml = { "yamllint" },

        -- Global linters: uncomment to run on every filetype.
        -- ["*"] = { "typos" },

        -- Fallback linters: uncomment to run when no ft linter is configured.
        -- ["_"] = { "typos" },
      }

      -- ── Per-linter config file guards ─────────────────────────────────────
      -- Linter name → config file patterns to search for (upward from buffer).
      -- A linter only runs if at least one pattern is found.
      -- Linters NOT listed here have no guard and always run when installed.
      --
      -- vim.fs.root(bufnr, patterns) — Neovim 0.10+ API.
      -- Replaces: vim.fs.find(patterns, { upward = true, path = ... })[1]
      -- Operates in the C core. Takes bufnr directly.
      local linter_guards = {
        -- eslint_d throws a hard error (not a lint warning) when no config
        -- is found. Both legacy .eslintrc* and v9 flat config formats included.
        eslint_d = {
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.json",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "eslint.config.ts",
        },

        -- golangci-lint without config runs all default analyzers — very slow.
        -- Only activate when the project has explicitly configured it.
        ["golangci-lint"] = {
          ".golangci.yaml",
          ".golangci.yml",
          ".golangci.toml",
          ".golangci.json",
        },
      }

      -- ── Guard check ───────────────────────────────────────────────────────
      -- Returns true if the linter should run for this buffer.
      -- Linters with no guard entry always pass.
      local function passes_guard(linter_name, bufnr)
        local patterns = linter_guards[linter_name]
        if not patterns then
          return true
        end
        return vim.fs.root(bufnr, patterns) ~= nil
      end

      -- ── Linter collection ─────────────────────────────────────────────────
      -- Mirrors the "*" / "_" logic from LazyVim's implementation.
      -- Returns the full list of linters to attempt for this buffer.
      local function get_linters(bufnr)
        local ft = vim.bo[bufnr].filetype

        -- Start with filetype-specific linters
        local names = vim.list_extend({}, lint.linters_by_ft[ft] or {})

        -- If no ft linters, use "_" fallback linters
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Always append "*" global linters
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        return names
      end

      -- ── Main lint trigger ─────────────────────────────────────────────────
      local function trigger_lint()
        local bufnr = vim.api.nvim_get_current_buf()

        -- Skip non-file buffers: terminals, oil, telescope, help, quickfix.
        -- Real files always have buftype == "".
        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        -- Buffer-local disable
        if vim.b[bufnr].disable_lint then
          return
        end

        -- Global session disable
        if vim.g.disable_lint then
          return
        end

        local all_linters = get_linters(bufnr)
        if #all_linters == 0 then
          return
        end

        -- Apply per-linter guards. Each linter is checked independently.
        -- A failed guard skips only that linter — others still run.
        local surviving = {}
        local seen = {}
        for _, name in ipairs(all_linters) do
          if not seen[name] then
            if passes_guard(name, bufnr) then
              table.insert(surviving, name)
              seen[name] = true
            end
          end
        end

        if #surviving == 0 then
          return
        end

        -- try_lint() silently skips linters whose binary is not installed.
        lint.try_lint(surviving)
      end

      -- ── Autocmd ───────────────────────────────────────────────────────────
      -- Uses the same LINT_EVENTS defined at the top of the file.
      -- Keeping lazy `event` and autocmd events in sync via one source of truth.
      vim.api.nvim_create_autocmd(LINT_EVENTS, {
        group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
        callback = trigger_lint,
      })
    end,
  },
}
