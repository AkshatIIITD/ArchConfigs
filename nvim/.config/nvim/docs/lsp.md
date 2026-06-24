# LSP Configuration

Neovim 0.12 — `mason-org/mason.nvim` v2 + `mason-org/mason-lspconfig.nvim` v2

---

## Directory structure

```
~/.config/nvim/
├── after/
│   └── lsp/                        ← your server settings (override lspconfig)
│       ├── lua_ls.lua
│       ├── ts_ls.lua
│       ├── gopls.lua
│       ├── jsonls.lua
│       └── yamlls.lua
└── lua/
    └── plugins/
        └── lsp/
            ├── mason.lua           ← binary installer
            ├── servers.lua         ← nvim-lspconfig + mason-lspconfig
            ├── attach.lua          ← capabilities, keymaps, LspAttach
            ├── diagnostics.lua     ← tiny-inline-diagnostic
            └── extras.lua          ← lazydev, nvim-lsp-file-operations
```

---

## How the layers interact

### 1. Binary installation — mason.nvim

Installs language server binaries to `~/.local/share/nvim/mason/bin/`. Each binary is automatically on PATH for Neovim. Mason v2 removed `get_install_path()` — binaries are resolved via PATH automatically.

### 2. Server definitions — nvim-lspconfig

Provides `lsp/*.lua` files on runtimepath. Each file defines `cmd`, `filetypes`, and `root_markers` for one server. These are the base definitions the community maintains.

**You never call `require('lspconfig')` directly.** That API is deprecated in favour of `vim.lsp.config()` and will be removed in a future Neovim version.

### 3. Server enabling — mason-lspconfig

Translates lspconfig names (`lua_ls`) to mason package names (`lua-language-server`). With `automatic_enable = true` (the default), it calls `vim.lsp.enable()` for every server installed via Mason. You do not need to call `vim.lsp.enable()` manually for these servers.

### 4. Your settings — `after/lsp/`

Files in `after/lsp/` are loaded **after** `lsp/` files from all plugins. This guarantees your settings win over lspconfig defaults when there is a conflict.

> `lsp/` → written by nvim-lspconfig (cmd, filetypes, root_markers)  
> `after/lsp/` → written by you (settings, hints, capabilities overrides)

Each file must return a `vim.lsp.Config` table. You only write what you want to override — you do not repeat `cmd`, `filetypes`, or `root_markers`.

```lua
-- after/lsp/example.lua
---@type vim.lsp.Config
return {
  settings = {
    -- server-specific settings here
  },
}
```

### 5. Capabilities — `attach.lua`

`vim.lsp.config("*", { capabilities = ... })` sets capabilities for all servers using the wildcard. blink.cmp exposes `blink.get_lsp_capabilities()` which tells every server what the completion client can handle (snippet support, resolve capabilities, etc.).

### 6. Keymaps — `LspAttach` in `attach.lua`

Runs once per buffer when any LSP server attaches. Only maps keys that Neovim does not already provide.

---

## Default keymaps (Neovim 0.11+)

These are set globally at startup. They do nothing when no LSP is attached. **Do not remap them.**

| Key | Action |
|---|---|
| `K` | Hover documentation |
| `grn` | Rename symbol |
| `gra` | Code action (Normal + Visual) |
| `grr` | References |
| `gri` | Implementation |
| `grt` | Type definition |
| `grx` | Run codelens |
| `gO` | Document symbols |
| `<C-s>` | Signature help (Insert mode) |

## Keymaps added in `LspAttach`

| Key | Action | Why not a default |
|---|---|---|
| `gd` | Go to definition (telescope) | Not in Neovim defaults |
| `gD` | Go to declaration | Not in Neovim defaults |
| `<leader>ch` | Toggle inlay hints | Not in Neovim defaults |

---

## Adding a language server

**Step 1.** Add the server name to `ensure_installed` in `lua/plugins/lsp/servers.lua`:

```lua
ensure_installed = {
  "lua_ls",
  "pyright",   -- add this
},
```

**Step 2.** If you need custom settings, create `after/lsp/<server_name>.lua`:

```lua
-- after/lsp/pyright.lua
---@type vim.lsp.Config
return {
  settings = {
    python = {
      analysis = { typeCheckingMode = "standard" },
    },
  },
}
```

That is the complete process. Mason installs the binary. mason-lspconfig enables it. Your `after/lsp/` file applies your settings on top.

---

## Diagnostics

`tiny-inline-diagnostic.nvim` replaces Neovim's default `virtual_text` rendering. Diagnostics appear as inline overlays that do not shift any lines. Neovim's default virtual_text is disabled in `diagnostics.lua` after setup.

To debug which diagnostics are active on the current line:

```
:lua vim.diagnostic.open_float()
```

---

## Utilities

### lazydev.nvim

Configures `lua_ls` dynamically for Neovim config editing. Only loads on Lua filetypes. Provides `require()` path completions through blink.cmp's `lazydev` source.

Do **not** set `workspace.library` in `after/lsp/lua_ls.lua` — lazydev manages this at runtime.

### nvim-lsp-file-operations

Sends `workspace/willRenameFiles` and `workspace/didRenameFiles` notifications when files are moved. This is what causes `ts_ls` to update import paths automatically. Works with oil.nvim, neo-tree, nvim-tree.

Neovim core has no equivalent. `vim.lsp.util.rename` renames the file on disk but does not notify the server.

---

## Debugging

Check server status and enabled configurations:

```
:checkhealth vim.lsp
:LspInfo
:lua print(vim.inspect(vim.lsp.get_clients()))
```

Check loaded `after/lsp/` files:

```
:lua print(vim.inspect(vim.lsp.config["lua_ls"]))
```

Check Mason package status:

```
:Mason
:MasonLog
```

---

## Future improvements

The following are deliberate omissions — they require non-trivial extra configuration and are better added independently when needed.

| Feature | How to add |
|---|---|
| Rust (enhanced) | Replace `rust_analyzer` entry with `mrcjkb/rustaceanvim` |
| Java | `nvim-jdtls` — jdtls requires special per-project setup |
| Vue (Volar + ts_ls) | See mason-lspconfig Vue hybrid mode docs |
| Per-project server config | `.nvim.lua` in project root with `vim.lsp.config()` call |
| Python with ruff LSP | Add `ruff` to `ensure_installed`, disable pyright diagnostics |
