-- lua/plugins/colorscheme.lua
--
-- ─── TO SWITCH YOUR DEFAULT ───────────────────────────────────────────────────
-- Change ONE line only:
local active = "catppuccin-mocha"
--
-- Everything else — lazy loading, priority, colorscheme call — derives from it.
--
-- Valid values:
--   "tokyonight-storm"  | "tokyonight-night" | "tokyonight-moon" | "tokyonight-day"
--   "catppuccin-latte"  | "catppuccin-frappe" | "catppuccin-macchiato" | "catppuccin-mocha"
--   "kanagawa-wave"     | "kanagawa-dragon"   | "kanagawa-lotus"
--   "rose-pine-main"    | "rose-pine-moon"    | "rose-pine-dawn"
--
-- ─── HOW IT WORKS ─────────────────────────────────────────────────────────────
--
-- Each plugin has a config function that:
--   1. Calls setup(opts) — because lazy.nvim skips auto-setup when config is present
--   2. Calls vim.cmd.colorscheme() only if this plugin matches `active`
--
-- lazy and priority are derived from `active` so only the matching plugin
-- loads at startup. The others stay lazy and are loaded on demand by
-- telescope's colorscheme picker (<leader>fC).
--
-- plain = true in string.find() treats the search as a literal string,
-- not a Lua pattern. Safe for names like "rose-pine" that contain a hyphen.

local function is_active(name)
  return active:find(name, 1, true) ~= nil
end

return {

  -- ── catppuccin ──────────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = not is_active("catppuccin"),
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte | frappe | macchiato | mocha
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = { enabled = false },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        functions = {},
        keywords = {},
        variables = {},
      },
      -- catppuccin requires explicit flags per plugin to apply its highlights.
      -- Plugins not listed fall back to generic highlights (still works).
      integrations = {
        blink_cmp = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
          inlay_hints = { background = true },
        },
        telescope = { enabled = true },
        which_key = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      if is_active("catppuccin") then
        vim.cmd.colorscheme(active)
      end
    end,
  },

  -- ── tokyonight ──────────────────────────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    lazy = not is_active("tokyonight"),
    priority = 1000,
    opts = {
      style = "moon", -- storm | night | moon | day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      if is_active("tokyonight") then
        vim.cmd.colorscheme(active)
      end
    end,
  },

  -- ── kanagawa ────────────────────────────────────────────────────────────────
  {
    "rebelot/kanagawa.nvim",
    lazy = not is_active("kanagawa"),
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      transparent = false,
      terminalColors = true,
      theme = "wave", -- wave | dragon | lotus
      background = { dark = "wave", light = "lotus" },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      if is_active("kanagawa") then
        vim.cmd.colorscheme(active)
      end
    end,
  },

  -- ── rose-pine ───────────────────────────────────────────────────────────────
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = not is_active("rose-pine"),
    priority = 1000,
    opts = {
      variant = "moon", -- auto | main | moon | dawn
      dark_variant = "moon",
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      if is_active("rose-pine") then
        vim.cmd.colorscheme(active)
      end
    end,
  },
}
