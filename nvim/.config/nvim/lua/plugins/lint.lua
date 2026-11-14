-- lua/plugins/lint.lua
--
-- nvim-lint runs external linters and feeds vim.diagnostic (alongside LSP).
-- Linters are installed by mason-tools.lua; try_lint() skips any that are missing.
--
-- Events: BufReadPost, BufNewFile, BufWritePost, InsertLeave.
-- Linters that cannot read stdin (file_only) are skipped on InsertLeave, because
-- they would lint the stale saved file instead of the buffer.
--
-- Guards map a LINTER to config-file patterns searched upward from the buffer;
-- the linter only runs if one is found. A failed guard skips only that linter.
--
-- Disable: :lua vim.b.disable_lint = true (buffer) or vim.g.disable_lint = true (session).

local LINT_EVENTS = { "BufReadPost", "BufWritePost", "BufNewFile", "InsertLeave" }

-- Linters that need the file saved on disk (no stdin support).
local file_only = { golangcilint = true }

local guards = {
  -- eslint_d errors hard (not a lint warning) when no config is found.
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
    "eslint.config.mts",
  },

  -- sqlfluff errors without a dialect, which lives in .sqlfluff.
  sqlfluff = { ".sqlfluff" },

  -- golangci-lint without config runs every default analyzer, which is very slow.
  golangcilint = { ".golangci.yaml", ".golangci.yml", ".golangci.toml", ".golangci.json" },
}

return {
  {
    "mfussenegger/nvim-lint",
    event = LINT_EVENTS, -- keep in sync with the autocmd events below

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

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },

        python = { "ruff" },
        go = { "golangcilint" },

        sh = { "shellcheck" },
        bash = { "shellcheck" },

        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        sql = { "sqlfluff" },
      }

      local function trigger_lint(args)
        local bufnr = vim.api.nvim_get_current_buf()

        -- Real files have buftype == "" (skips terminals, oil, telescope, help, quickfix).
        if vim.bo[bufnr].buftype ~= "" or vim.b[bufnr].disable_lint or vim.g.disable_lint then
          return
        end

        -- Compound filetypes such as "yaml.docker-compose" use the linters of each part.
        local on_insert_leave = args and args.event == "InsertLeave"
        local names, seen = {}, {}
        for part in vim.bo[bufnr].filetype:gmatch("[^.]+") do
          for _, name in ipairs(lint.linters_by_ft[part] or {}) do
            local patterns = guards[name]
            if
              not seen[name]
              and (not patterns or vim.fs.root(bufnr, patterns))
              and not (on_insert_leave and file_only[name])
            then
              seen[name] = true
              table.insert(names, name)
            end
          end
        end

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(LINT_EVENTS, {
        group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
        callback = trigger_lint,
      })
    end,
  },
}
