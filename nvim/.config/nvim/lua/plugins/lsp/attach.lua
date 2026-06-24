-- lua/plugins/lsp/attach.lua
--
-- Two responsibilities:
--   1. Global LSP capabilities — tell every server what blink.cmp supports
--   2. LspAttach — buffer-local keymaps and feature setup per server
--
-- ─── NEOVIM 0.11/0.12 DEFAULT KEYMAPS (already exist, do not remap) ──────────
--
--   K        → hover documentation
--   grn      → rename symbol
--   gra      → code action (Normal + Visual)
--   grr      → references
--   gri      → implementation
--   grt      → type definition
--   grx      → run codelens at cursor
--   gO       → document symbols
--   <C-s>    → signature help (Insert mode)
--
-- ─── WHAT THIS FILE ADDS ──────────────────────────────────────────────────────
--
--   gd             → go to definition (telescope picker)
--   gD             → go to declaration
--   <leader>ch     → toggle inlay hints
--
--   Per-server, checked with supports_method():
--     textDocument/inlayHint        → grey inline type/param annotations
--     textDocument/codeLens         → actionable annotations above functions
--     textDocument/documentHighlight → glow all refs to symbol under cursor
--     textDocument/foldingRange     → LSP-aware folding (beats treesitter folding)
--     textDocument/formatting       → wires gq to LSP formatexpr (NOT format-on-save,
--                                     that is conform.nvim's job)

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- ── 1. Global capabilities ──────────────────────────────────────────────
      -- Applied to every LSP server via the "*" wildcard.
      -- blink.cmp must be loaded before any server attaches (lazy=false).
      vim.lsp.config("*", {
        capabilities = (function()
          local ok, blink = pcall(require, "blink.cmp")
          if ok then
            return blink.get_lsp_capabilities()
          end
          return vim.lsp.protocol.make_client_capabilities()
        end)(),
      })

      -- ── 2. LspAttach ────────────────────────────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, {
              buffer = event.buf,
              desc = "LSP: " .. desc,
            })
          end

          -- ── Keymaps not in Neovim defaults ──────────────────────────────────

          map("grd", vim.lsp.buf.definition, "Go to Definition")
          map("grD", vim.lsp.buf.declaration, "Go to Declaration")
          map("grt", vim.lsp.buf.type_definition, "Go to Declaration")

          -- ── Copy Diagnostics ─────────────────────────────────────────────────────
          map("<leader>cy", function()
            -- Get current line number (0-indexed for the API)
            local line = vim.api.nvim_win_get_cursor(0)[1] - 1

            -- Fetch all diagnostics strictly for the current line
            local diags = vim.diagnostic.get(event.buf, { lnum = line })

            if vim.tbl_isempty(diags) then
              vim.notify("No diagnostics found on current line", vim.log.levels.INFO)
              return
            end

            -- Collect messages (filters out empty strings, merges multiple messages)
            local messages = {}
            for _, diag in ipairs(diags) do
              if diag.message and diag.message ~= "" then
                table.insert(messages, diag.message)
              end
            end

            local result = table.concat(messages, "\n\n")

            -- Copy to system clipboard register (+)
            vim.fn.setreg("+", result)

            -- Feedback notice
            vim.notify("Copied line diagnostics to clipboard!", vim.log.levels.INFO)
          end, "Yank line diagnostics")

          -- ── Inlay hints ─────────────────────────────────────────────────────
          -- Grey inline annotations: inferred types, parameter names.
          -- Enabled by default; toggle with <leader>ch.
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- ── Codelens ────────────────────────────────────────────────────────
          -- Actionable annotations servers render near code: "▶ Run test", "2 refs".
          -- Run with grx (Neovim default keymap — don't remap).
          -- vim.lsp.codelens.enable() is the 0.12 API.
          -- vim.lsp.codelens.refresh() is DEPRECATED (warns now, errors in 0.13).
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = event.buf })
          end

          -- ── Document highlight ───────────────────────────────────────────────
          -- Cursor rests on a symbol → all its references in the buffer glow.
          -- Clears automatically on cursor move. Visual only, no keymap needed.
          -- Controlled by updatetime option (200ms in options.lua).
          if client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
            vim.api.nvim_clear_autocmds({ group = hl, buffer = event.buf })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- ── LSP folding ─────────────────────────────────────────────────────
          -- Override Treesitter foldexpr with LSP foldexpr when the server
          -- supports it. LSP folding is semantically aware (real function/class
          -- boundaries) vs Treesitter which is syntactic.
          --
          -- Global fallback (in options.lua):
          --   vim.o.foldmethod = "expr"
          --   vim.o.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
          --
          -- This overrides it per-window when LSP can do better.
          -- vim.wo[win][0] sets it window+buffer-locally (from official docs).
          if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
          end

          -- ── formatexpr ──────────────────────────────────────────────────────
          -- Wires the `gq` motion to use LSP formatting instead of Vim's default
          -- internal formatter. Useful for: gq inside a function, gqq on a line,
          -- gq in visual mode to reformat a selection.
          --
          -- This is NOT format-on-save. That is conform.nvim's job (formatting.lua).
          -- These two do not conflict — conform runs on BufWritePre,
          -- formatexpr only runs when you explicitly press gq.
          if client:supports_method("textDocument/formatting") then
            vim.bo[event.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
          end
        end,
      })
    end,
  },
}
