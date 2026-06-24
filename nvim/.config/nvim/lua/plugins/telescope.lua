-- lua/plugins/telescope.lua
local function b(picker, opts)
  return function()
    require("telescope.builtin")[picker](opts or {})
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*", -- latest release tag
    lazy = true,
    cmd = "Telescope",

    dependencies = {
      "nvim-lua/plenary.nvim",

      -- telescope-fzf-native: C-compiled fzf sorting algorithm.
      -- Requires gcc + make (pacman -S base-devel).
      -- Does NOT require the fzf CLI tool to be installed.
      -- build = "make" compiles the .so on first install.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },

      -- telescope-ui-select: replaces vim.ui.select() with a telescope picker.
      -- Affects code actions, rename prompts, and any plugin using vim.ui.select().
      -- No keymaps needed — registering the extension is enough.
      "nvim-telescope/telescope-ui-select.nvim",
    },

    keys = {
      -- ── Files ─────────────────────────────────────────────────────────────────
      -- Normal files (respects .gitignore — the common case)
      { "<leader>ff", b("find_files"), desc = "Find files" },
      -- Include hidden dotfiles (.env, .github/, .eslintrc, etc.)
      { "<leader>fF", b("find_files", { hidden = true }), desc = "Find files (+ hidden)" },
      -- Ignore gitignore entirely — find EVERYTHING (slow on big repos)
      { "<leader>fa", b("find_files", { hidden = true, no_ignore = true }), desc = "Find ALL files" },
      -- Recent files (mru)
      { "<leader>fr", b("oldfiles"), desc = "Recent files" },

      -- ── Search / Grep ──────────────────────────────────────────────────────────
      -- Full horizontal layout — grep needs space to show results and preview
      {
        "<leader>fg",
        b("live_grep"),
        desc = "Live grep",
      },
      {
        "<leader>fG",
        b("live_grep", { additional_args = { "--hidden" } }),
        desc = "Live grep (+ hidden)",
      },
      {
        "<leader>fw",
        b("grep_string"),
        desc = "Grep word under cursor",
      },
      {
        "<leader>fw",
        b("grep_string"),
        mode = "v",
        desc = "Grep selection",
      },
      {
        "<leader>f/",
        b("current_buffer_fuzzy_find"),
        desc = "Grep in buffer",
      },

      -- ── Buffers ────────────────────────────────────────────────────────────────
      { "<leader>fb", b("buffers", { sort_mru = true, sort_lastused = true }), desc = "Buffers" },
      -- Quick buffer switch (like Ctrl+Tab in VSCode)
      { "<leader><leader>", b("buffers", { sort_mru = true }), desc = "Switch buffer" },

      -- ── LSP pickers (deliberate actions, NOT motion overrides) ────────────────
      -- These are "open a picker" keymaps that the user explicitly invokes.
      -- gd / gr / gI / gy are NOT here — those override vim defaults and must
      -- only activate when LSP is attached. Set them in LspAttach in lsp.lua.
      {
        "<leader>fs",
        b("lsp_document_symbols"),
        desc = "Document symbols",
      },
      {
        "<leader>fS",
        b("lsp_workspace_symbols"),
        desc = "Workspace symbols",
      },
      {
        "<leader>fd",
        b("diagnostics", { bufnr = 0 }),
        desc = "Buffer diagnostics",
      },
      {
        "<leader>fD",
        b("diagnostics"),
        desc = "All diagnostics",
      },

      -- ── Git ────────────────────────────────────────────────────────────────────
      -- { "<leader>gs", b("git_status"),                                                                             desc = "Git status" },
      -- { "<leader>gc", b("git_commits"),                                                                            desc = "Git commits" },
      -- { "<leader>gC", b("git_bcommits"),                                                                           desc = "Git commits (buffer)" },
      -- { "<leader>gb", b("git_branches"),                                                                           desc = "Git branches" },
      -- { "<leader>gS", b("git_stash"),                                                                              desc = "Git stash" },
      -- { "<leader>gf", b("git_files"),                                                                              desc = "Git-tracked files" },

      -- ── Vim / Neovim internals ─────────────────────────────────────────────────
      -- Compact dropdown for short lists that don't need preview
      {
        "<leader>fc",
        b("commands"),
        desc = "Commands (palette)",
      },
      {
        "<leader>fk",
        b("keymaps"),
        desc = "Keymaps",
      },
      {
        "<leader>fh",
        b("help_tags"),
        desc = "Help tags",
      },
      {
        '<leader>"',
        b("registers"),
        desc = "Registers",
      },
      {
        "<leader>fj",
        b("jumplist"),
        desc = "Jump list",
      },
      {
        "<leader>fq",
        b("quickfix"),
        desc = "Quickfix list",
      },
      -- Spell suggest as compact dropdown — no preview needed for a word list
      { "z=", b("spell_suggest"), desc = "Spell suggest" },
      -- Resume the last picker exactly where you left it — use this constantly
      {
        "<leader>fp",
        "<cmd>Telescope resume<CR>",
        desc = "Resume last picker",
      },
      -- Treesitter symbols — works without LSP, useful as a fallback
      {
        "<leader>ft",
        b("treesitter"),
        desc = "Treesitter symbols",
      },

      -- ── Colorscheme ────────────────────────────────────────────────────────────
      -- Full picker with preview — the whole point is seeing the theme live
      {
        "<leader>fC",
        b("colorscheme", { enable_preview = true }),
        desc = "Colorschemes",
      },
    },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- ── Layout ─────────────────────────────────────────────────────────────
          -- Prompt at the top, results grow downward (more VSCode-like).
          -- sorting_strategy = "ascending" must match prompt_position = "top".
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.5,
            },
            width = 0.9,
            height = 0.85,
          },
          sorting_strategy = "ascending",

          -- ── Path display ───────────────────────────────────────────────────────
          -- "truncate" shows the full path but cuts from the left when narrow.
          -- Alternatives: "smart" (unique suffix only), "filename_first"
          path_display = { "truncate" },

          -- ── rg args for live_grep / grep_string ───────────────────────────────
          -- These are close to telescope's defaults — listed here for visibility.
          -- Uncomment --hidden to grep inside dotfiles by default (or use <leader>fG).
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- "--hidden",        -- uncomment to grep dotfiles by default
            -- "--glob", "!.git", -- only needed alongside --hidden above
          },

          -- ── Keymaps inside the picker ──────────────────────────────────────────
          mappings = {
            i = {
              -- Vim-style navigation in the results list
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- History navigation
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              -- Send only Tab-selected items to quickfix (intentional, not all results)
              -- Use <Tab> to mark items first, then <C-q>
              ["<C-q>"] = actions.send_selected_to_qflist,
              -- Send ALL results to quickfix (no selection needed)
              ["<M-q>"] = actions.send_to_qflist,
              -- Open in splits / new tab
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- Close picker
              ["<Esc>"] = actions.close,
              -- Scroll the preview pane while staying in the prompt
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              -- Show all available keymaps for the current picker
              ["<C-h>"] = "which_key",
            },
            n = {
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },

        -- ── Per-picker overrides ────────────────────────────────────────────────
        pickers = {
          find_files = {
            -- fd is faster than rg or find for file discovery.
            -- nil = telescope auto-selects rg or find as fallback.
            -- No --hidden here: dotfiles excluded by default (use <leader>fF to include).
            -- No --exclude .git: already excluded by gitignore.
            find_command = vim.fn.executable("fd") == 1 and { "fd", "--type", "f", "--color", "never" } or nil,
          },

          lsp_references = { show_line = false },
          lsp_definitions = { show_line = false },

          buffers = {
            sort_mru = true,
            sort_lastused = true,
            mappings = {
              -- Delete a buffer directly from the picker without opening it
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["d"] = actions.delete_buffer },
            },
          },

          colorscheme = { enable_preview = true },
        },

        -- ── Extensions ─────────────────────────────────────────────────────────
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true, -- fzf sorts all generic lists
            override_file_sorter = true, -- fzf sorts file lists
            case_mode = "smart_case",
          },

          -- ui-select: controls the theme used when vim.ui.select() is called.
          -- "dropdown" keeps it compact — code action lists are usually short.
          -- Change to get_cursor({}) for a cursor-relative popup instead.
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Load native fzf sorter (compiled C, significantly faster than Lua sorter)
      pcall(telescope.load_extension, "fzf")

      -- Load ui-select — this is what actually overrides vim.ui.select().
      -- Must be called AFTER telescope.setup(), otherwise the extension
      -- config above won't have been registered yet.
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
