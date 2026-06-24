-- lua/plugins/lsp/blink.lua
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false, -- Blink should load immediately to handle its internal caching
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "none",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-space>"] = { "show", "hide" },
      },

      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },

      completion = {
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
        ghost_text = { enabled = false },
        accept = { auto_brackets = { enabled = true } },
      },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- Pushes Neovim API suggestions to the top
          },
          buffer = {
            min_keyword_length = 3,
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      snippets = { preset = "default" },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      cmdline = {
        completion = {
          menu = { auto_show = true },
        },
        keymap = {
          preset = "cmdline",
          ["<CR>"] = { "fallback" },
          ["<Tab>"] = { "accept", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
        },
      },
    },
    -- Allows other plugins to safely inject their own completion sources
    opts_extend = { "sources.default" },
  },
}
