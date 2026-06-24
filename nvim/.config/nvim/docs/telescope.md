# Telescope Configuration Documentation

## 1. Versioning
- Use `version = "*"` to pin to the latest GitHub release tag. 
- Avoid using `branch = "master"` to ensure production configuration stability.

## 2. Search Tools & Ignore Behavior (fd & rg)
Telescope relies on external tools for efficient searching. By default, manual configuration for file ignoring is not required.
- **fd (find_files):** Natively respects `.gitignore`, `.ignore`, and `.fdignore`. Automatically skips the `.git/` directory. Does not show hidden files (dotfiles) by default; requires the `--hidden` flag to include them.
- **rg (live_grep / grep_string):** Natively respects `.gitignore`, `.ignore`, and `.rgignore`. Skips binary files. Does not search hidden files by default; requires the `--hidden` flag.
- **Performance Note:** Avoid using Telescope's Lua-level `file_ignore_patterns` for standard ignores (like `node_modules/` or `dist/`). It runs after `fd`/`rg` filtering and introduces significant performance overhead.

## 3. System Requirements
- `ripgrep` (rg): Required for `live_grep` and `grep_string`.
- `fd`: Required for optimized `find_files` execution.
- `gcc` / `make`: Required to compile the `telescope-fzf-native` C extension. (The standalone `fzf` CLI tool is not required).
- `bat` (Optional): Required for syntax-highlighted file previews.

## 4. Architecture Notes

### LSP Keybindings Distribution
- **Navigation Overrides (gd, gr, gI, gy):** These override default Vim motions. They belong in the `LspAttach` autocommand within the LSP configuration (`lsp.lua`) and should only activate when an LSP is actively attached to the buffer.
- **Deliberate Actions (<leader>fs, <leader>fd):** Explicit Telescope picker invocations belong in the Telescope configuration.

### UI Select (telescope-ui-select)
- Replaces the native Neovim `vim.ui.select()` command-line prompt with a fuzzy-searchable Telescope dropdown.
- Automatically affects LSP code actions, rename prompts, and any external plugin utilizing the native `vim.ui.select` API.


## 5. Keymaps & Workflows

### Standard Picker Navigation
- `<C-h>`: Display all available keymaps for the active picker.
- `<Tab>`: Multi-select an item.
- `<C-s>` / `<C-v>` / `<C-t>`: Open selection in a horizontal split, vertical split, or new tab.
- `<C-d>` / `<C-u>`: Scroll the preview pane.

### Quickfix Batch Operations
- `<C-q>`: Send selected (Tab-marked) items to the quickfix list.
- `<M-q>`: Send all search results to the quickfix list.
- **Batch replace across files:** `:cfdo %s/Old/New/g | update` (Executes per file).
- **Batch replace across matches:** `:cdo s/Old/New/g | update` (Executes per match line).

### Advanced Workflows
- **Resume Picker:** `<leader>fp` reopens the last closed picker, preserving its exact state and search query.
- **Inline Help:** `<leader>fh` searches and previews Neovim `:help` documentation within the editor flow.
- **Register Access:** `<leader>"` displays all registers and their contents for quick pasting.
- **Spell Check:** `z=` on a misspelled word opens a dropdown of corrections.
- **Treesitter Symbols:** `<leader>ft` navigates functions, classes, and variables without requiring an active Language Server.
- **Buffer Management:** `<leader>fb` opens the buffer list; pressing `<C-d>` deletes the highlighted buffer without switching to it.
- **Theme Switching:** `<leader>fC` cycles through colorschemes with live visual previews.
