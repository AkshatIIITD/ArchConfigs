# Neovim 2026 Keymaps

This document outlines the custom keymaps configured in your Neovim setup, along with the standard Neovim 0.12+ LSP keymaps.

---

## 1. General Keymaps

### Window Management
| Keymap        | Description               |
| :------------ | :------------------------ |
| `<leader>wh`  | Split window horizontally |
| `<leader>wv`  | Split window vertically   |
| `<leader>we`  | Make splits equal size    |
| `<leader>wc`  | Close current window      |
| `<C-A-j>`     | Move line down            |
| `<C-A-k>`     | Move line up              |
| `<C-A-j>` (`v`)| Move selection down       |
| `<C-A-k>` (`v`)| Move selection up         |
| `<C-h>`       | Go to left window         |
| `<C-j>`       | Go to lower window        |
| `<C-k>`       | Go to upper window        |
| `<C-l>`       | Go to right window        |

### Tab Management
| Keymap        | Description         |
| :------------ | :------------------ |
| `<leader><tab>`| Create new tab      |
| `<M-1>` - `<M-9>`| Go to tab 1-9       |

### Clear Screen / Highlights
| Keymap        | Description                        |
| :------------ | :--------------------------------- |
| `<C-A-L>`     | Clear screen and search highlights |

### Copy & Paste
| Keymap        | Description                       |
| :------------ | :-------------------------------- |
| `<leader>y`   | Copy to system clipboard          |
| `<leader>p`   | Paste from system clipboard       |
| `<leader>d`   | Cut to system clipboard           |

### Commenting
| Keymap        | Description           |
| :------------ | :-------------------- |
| `<leader>/`   | Toggle Comment Line   |
| `<leader>/` (`v`)| Toggle Comment Selection|

### Native Quickfix
| Keymap        | Description              |
| :------------ | :----------------------- |
| `<leader>q`   | Toggle Native Quickfix   |

---

## 2. Plugin-Specific Keymaps

### Todo-Comments
| Keymap        | Description           |
| :------------ | :-------------------- |
| `]t`          | Todo: next            |
| `[t`          | Todo: prev            |
| `]T`          | Todo: next TODO/FIX   |
| `[T`          | Todo: prev TODO/FIX   |
| `<leader>tq`  | Todo: all (telescope) |
| `<leader>Tq`  | Todo: TODO/FIX (telescope) |

### Telescope
| Keymap        | Description               |
| :------------ | :------------------------ |
| `<leader>ff`  | Find files                |
| `<leader>fF`  | Find files (+ hidden)     |
| `<leader>fa`  | Find ALL files            |
| `<leader>fr`  | Recent files              |
| `<leader>fg`  | Live grep                 |
| `<leader>fG`  | Live grep (+ hidden)      |
| `<leader>fw`  | Grep word under cursor    |
| `<leader>fw` (`v`)| Grep selection          |
| `<leader>f/`  | Grep in buffer            |
| `<leader>fb`  | Buffers                   |
| `<leader><leader>`| Switch buffer             |
| `<leader>fs`  | Document symbols          |
| `<leader>fS`  | Workspace symbols         |
| `<leader>fd`  | Buffer diagnostics        |
| `<leader>fD`  | All diagnostics           |
| `<leader>fc`  | Commands (palette)        |
| `<leader>fk`  | Keymaps                   |
| `<leader>fh`  | Help tags                 |
| `<leader>"`   | Registers                 |
| `<leader>fj`  | Jump list                 |
| `<leader>fq`  | Quickfix list             |
| `z=`          | Spell suggest             |
| `<leader>fp`  | Resume last picker        |
| `<leader>ft`  | Treesitter symbols        |
| `<leader>fC`  | Colorschemes              |

### Trouble
| Keymap        | Description                  |
| :------------ | :--------------------------- |
| `<leader>xX`  | Diagnostics (Trouble)        |
| `<leader>xx`  | Buffer Diagnostics (Trouble) |
| `<leader>cs`  | Symbols (Trouble)            |

### Mini.pairs (Autopairs)
| Keymap        | Description               |
| :------------ | :------------------------ |
| `<leader>tp`  | Toggle autopairs (buffer) |
| `<leader>tP`  | Toggle autopairs (global) |

### GitSigns
| Keymap        | Description                 |
| :------------ | :-------------------------- |
| `]h`          | Next Hunk                   |
| `[h`          | Prev Hunk                   |
| `<leader>hs`  | Stage Hunk                  |
| `<leader>hr`  | Reset Hunk                  |
| `<leader>hs` (`v`)| Stage Selection           |
| `<leader>hr` (`v`)| Reset Selection           |
| `<leader>hS`  | Stage Entire Buffer         |
| `<leader>hR`  | Reset Entire Buffer         |
| `<leader>hp`  | Preview Hunk (Float)        |
| `<leader>hi`  | Preview Hunk (Inline)       |
| `<leader>hb`  | Blame Line                  |
| `<leader>hd`  | Diff Against Index          |
| `<leader>hD`  | Diff Against Last Commit    |
| `<leader>hq`  | Hunks to Quickfix           |
| `<leader>hQ`  | All Hunks to Quickfix       |
| `<leader>tb`  | Toggle Line Blame           |
| `<leader>tw`  | Toggle Word Diff            |
| `ih` (`o`,`x`)| Select Hunk                 |

### Harpoon
| Keymap        | Description              |
| :------------ | :----------------------- |
| `<leader>a`   | Harpoon: Add file        |
| `<leader>m`   | Harpoon: Quick menu      |
| `<leader>1`   | Harpoon: Navigate to file 1 |
| `<leader>2`   | Harpoon: Navigate to file 2 |
| `<leader>3`   | Harpoon: Navigate to file 3 |
| `<leader>4`   | Harpoon: Navigate to file 4 |

### Oil.nvim
| Keymap        | Description                   |
| :------------ | :---------------------------- |
| `-`           | Open parent directory         |
| `<leader>e`   | Toggle Explorer (Oil Float)   |

### nvim-lint
| Keymap        | Description           |
| :------------ | :-------------------- |
| `<leader>cl`  | Lint current buffer   |
| `<leader>tl`  | Toggle lint (buffer)  |

### Conform.nvim
| Keymap        | Description                 |
| :------------ | :-------------------------- |
| `<leader>cf`  | Format file / selection     |
| `<leader>tf`  | Toggle format on save       |

### Neogit
| Keymap        | Description    |
| :------------ | :------------- |
| `<leader>gg`  | Neogit         |

### Diffview.nvim
| Keymap        | Description                 |
| :------------ | :-------------------------- |
| `<leader>gd`  | Diffview Open               |
| `<leader>gx`  | Diffview Close              |
| `<leader>gf`  | Toggle Diff File Panel      |
| `<leader>gH`  | File History (Current)      |
| `<leader>gB`  | Branch History (All)        |

---

## 3. Neovim 0.12+ Standard LSP Keymaps (starting with `gr`)

These keymaps are typically set when an LSP server is attached to a buffer.

| Keymap        | Description           |
| :------------ | :-------------------- |
| `grn`         | Rename symbol         |
| `gra`         | Code action           |
| `grr`         | References            |
| `gri`         | Implementation        |
| `grt`         | Type definition       |
| `grx`         | Run codelens at cursor|
| `grd`         | Go to Definition      |
| `grD`         | Go to Declaration     |
| `grt`         | Go to Type Definition |
| `<leader>cy`  | Yank line diagnostics |
| `<leader>ch`  | Toggle inlay hints    |
