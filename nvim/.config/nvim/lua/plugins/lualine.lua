-- lua/plugins/lualine.lua

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true, -- single statusline for all windows
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {
          "trouble",
          "neogit",
          "neogit-status",
          "DiffviewFiles",
          "DiffviewFileHistory",
          "lazy",
          "mason",
        },
      },
      refresh = {
        statusline = 1000,
      },
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        {
          "filename",
          path = 1, -- relative path
          symbols = {
            modified = "●",
            readonly = "",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" }, -- nvim_lsp is deprecated
          sections = { "error", "warn", "info", "hint" },
        },
        "lsp_status", -- built-in: shows active LSP + spinner
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
