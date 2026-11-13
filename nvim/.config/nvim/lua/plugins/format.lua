-- lua/plugins/format.lua
--
-- conform.nvim: formatters are external binaries, installed by mason-tools.lua
-- (rustfmt comes from the Rust toolchain). Check what is available with :ConformInfo.
--
-- Several formatters in one list run in sequence (a pipeline).
-- Add `stop_after_first = true` to use only the first installed one instead.
-- lsp_format = "fallback" uses the LSP only when no formatter matches the filetype.

-- Filetypes that are never formatted on save (manual <leader>cf still works).
-- Prettier reindents Kubernetes YAML and breaks Helm's {{ }} templates.
local skip_ft = { yaml = true, helm = true }

local prettier = { "prettier" }

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,

    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format file / selection",
      },

      -- Toggle format-on-save for the current session (does not persist).
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
      formatters_by_ft = {
        lua = { "stylua" },

        -- Web, data and docs: prettier
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        html = prettier,
        css = prettier,
        scss = prettier,
        graphql = prettier,
        json = prettier,
        jsonc = prettier,
        yaml = prettier,
        markdown = prettier,

        -- Python: ruff sorts imports first, then formats (one binary, no black/isort)
        python = { "ruff_organize_imports", "ruff_format" },

        go = { "goimports" }, -- gofmt + import organisation
        rust = { "rustfmt" }, -- from the Rust toolchain, not mason
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },

      default_format_opts = {
        lsp_format = "fallback",
      },

      -- Function form: return nil to skip, return an options table to format.
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- compound filetypes such as "yaml.helm-values" are split on "."
        for part in vim.bo[bufnr].filetype:gmatch("[^.]+") do
          if skip_ft[part] then
            return
          end
        end

        -- skip files over 1 MB
        local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stat and stat.size > 1024 * 1024 then
          return
        end

        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,

      -- Only what differs from each formatter's defaults or project config.
      formatters = {
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        shfmt = { prepend_args = { "-i", "2" } },
      },
    },
  },
}
