return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    git = {
      -- Return true to automatically git add/mv/rm files
      add = function(path)
        return false
      end,
      mv = function(src_path, dest_path)
        return true
      end,
      rm = function(path)
        return false
      end,
    },
    float = {
      padding = 2,
      max_width = 0.8, -- Takes up 80% of screen width
      max_height = 0.8, -- Takes up 80% of screen height
      border = "rounded",

      --winblend = 0 means 100% solid. No background text will bleed through.
      win_options = { winblend = 0 },

      -- Adds a beautiful title to the top center of the border
      get_win_title = function()
        return " 󰝰 File Explorer "
      end,

      -- When you open a preview, it will elegantly split to the right of the float
      preview_split = "right",
    },
    -- ── 3. The Confirmation Popup ───────────────────────────────────────────
    confirmation = {
      max_width = 0.6, -- Slightly smaller than the main explorer
      max_height = 0.6,
      border = "rounded",
      win_options = { winblend = 0 },
    },

    -- ── 4. The Progress/Loading Bar ─────────────────────────────────────────
    progress = {
      max_width = 0.5,
      min_width = { 40, 0.4 },
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      border = "rounded",
      minimized_border = "rounded",
      win_options = { winblend = 0 },
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-mini/mini.icons" },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  keys = {
    -- The classic Oil keybind: dash opens the parent directory in the current buffer
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    -- Optional: If you just want to quickly peek at files without losing your split,
    -- this opens Oil in a floating popup window.
    -- Toggles the floating Oil window (opens it if closed, closes it if open)
    {
      "<leader>e",
      function()
        require("oil").toggle_float()
      end,
      desc = "Toggle Explorer (Oil Float)",
    },
  },
}
