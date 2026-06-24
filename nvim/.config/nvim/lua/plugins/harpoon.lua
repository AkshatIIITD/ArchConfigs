-- lua/plugins/harpoon.lua
--
-- Harpoon 2 — The fastest way to navigate between your 4 or 5 active files.
-- Replaces tabs and buffers with a project-specific, persistent floating menu.
--
-- NOTE: The original Harpoon is deprecated. You MUST use branch = "harpoon2".

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  -- We use `opts` to define settings, which are automatically passed to the
  -- `config` function below.
  opts = {
    settings = {
      -- Instantly saves your list to the hard drive anytime you toggle the UI closed
      -- so you don't lose your marks if Neovim crashes.
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },

  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)
  end,

  -- ── Lazy-loaded Keymaps ───────────────────────────────────────────────────
  -- By defining keys here instead of vim.keymap.set(), lazy.nvim will NOT load
  -- Harpoon into memory until you actually press one of these keys.
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon: Add file",
    },
    {
      "<leader>m",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon: Quick menu",
    },
    {
      "<leader>1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon: Navigate to file 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon: Navigate to file 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon: Navigate to file 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon: Navigate to file 4",
    },
  },
}
