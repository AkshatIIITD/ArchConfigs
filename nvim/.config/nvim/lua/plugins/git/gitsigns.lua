-- lua/plugins/git/gitsigns.lua

return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = " +" },
      change = { text = " ~" },
      delete = { text = " -" },
      topdelete = { text = " -" },
      changedelete = { text = " ~" },
      untracked = { text = " ?" },
    },
    signs_staged = {
      add = { text = " ┃" },
      change = { text = " ┃" },
      delete = { text = " ┃" },
      topdelete = { text = " ┃" },
      changedelete = { text = " ┃" },
      untracked = { text = " ┃" },
    },
    signs_staged_enable = true,
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    blame_formatter = nil, -- Use default
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigation (Enforcing the ]h and [h Hunk system)
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next Hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Prev Hunk")

      -- Actions (<leader>h prefix for "Hunk")
      map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
      map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")
      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage Selection")
      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset Selection")

      map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Entire Buffer")
      map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Entire Buffer")
      map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk (Float)")
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview Hunk (Inline)")

      -- Blame & Diff
      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame Line")
      map("n", "<leader>hd", gitsigns.diffthis, "Diff Against Index")
      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, "Diff Against Last Commit")

      -- Quickfix

      -- 0 targets the current buffer only
      map("n", "<leader>hq", function()
        gitsigns.setqflist(0, { open = false })
      end, "Hunks to Quickfix")

      -- "all" targets the entire repository/workspace
      map("n", "<leader>hQ", function()
        gitsigns.setqflist("all", { open = false })
      end, "All Hunks to Quickfix")

      -- Toggles (Moved under the global UI toggle prefix <leader>t)
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
      map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle Word Diff")

      -- Text object (Allows you to type 'dih' to delete inside a hunk)
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
    end,
  },
}
