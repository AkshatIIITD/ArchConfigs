-- lua/plugins/autopairs.lua
--
-- ─── WHY mini.pairs OVER nvim-autopairs ───────────────────────────────────────
--
-- nvim-autopairs has a blink.cmp integration gap:
--   The cmp_autopairs.on_confirm_done() integration hooks into nvim-cmp's
--   confirm_done event. The maintainer marked blink.cmp support as wontfix.
--   This means the "auto-insert ( after function completion" feature of
--   nvim-autopairs does not work with blink.cmp.
--
-- This doesn't matter because blink.cmp handles it natively:
--   completion.accept.auto_brackets.enabled = true in blink.lua already
--   inserts () after confirming a function/method completion item.
--
-- mini.pairs:
--   - Part of echasnovski/mini.nvim — actively maintained
--   - No completion plugin integration needed or expected
--   - Works correctly with blink.cmp out of the box
--   - Lighter than nvim-autopairs (no rule engine, no handler system)
--
-- ─── TOGGLE VARIABLES ─────────────────────────────────────────────────────────
--
-- mini.pairs respects two built-in variables — no custom logic needed:
--
--   vim.g.minipairs_disable = true   → disables globally for the session
--   vim.b.minipairs_disable = true   → disables for the current buffer only
--
-- Setting either to false (or nil) re-enables pairing.
-- The buffer-local variable takes precedence over the global one.
--
-- Keymaps:
--   <leader>tp  → toggle autopairs for the current buffer
--   <leader>tP  → toggle autopairs globally for the session
--
-- ─── WHAT mini.pairs DOES ─────────────────────────────────────────────────────
--
-- Typing (  → inserts ()  and puts cursor between them
-- Typing "  → inserts ""  and puts cursor between them
-- Typing {  → inserts {}  and puts cursor between them
-- Cursor before )  → pressing ) skips over it instead of inserting
-- Pressing <BS> between a pair  → deletes both characters
--
-- ─── WHAT mini.pairs DOES NOT DO ──────────────────────────────────────────────
--
-- Treesitter-aware pairing (string context detection)  → use nvim-autopairs
-- FastWrap (<M-e> to wrap a word in brackets)          → use nvim-autopairs
-- Per-filetype rule customization via Rule()           → use nvim-autopairs
--
-- If you need any of the above, swap this file for nvim-autopairs.

return {
  {
    "echasnovski/mini.pairs",
    version = false, -- mini.nvim does not use semver tags; use HEAD
    event = "InsertEnter", -- only needed in insert mode

    keys = {
      {
        "<leader>tp",
        function()
          vim.b.minipairs_disable = not vim.b.minipairs_disable
          vim.notify(
            "Autopairs: " .. (vim.b.minipairs_disable and "disabled" or "enabled") .. " (buffer)",
            vim.log.levels.INFO
          )
        end,
        desc = "Toggle autopairs (buffer)",
      },
      {
        "<leader>tP",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          vim.notify(
            "Autopairs: " .. (vim.g.minipairs_disable and "disabled" or "enabled") .. " (global)",
            vim.log.levels.INFO
          )
        end,
        desc = "Toggle autopairs (global)",
      },
    },

    opts = {
      modes = { insert = true, command = false, terminal = false },

      -- neigh_pattern = "[^\\]." means: don't pair when preceded by a backslash.
      -- The "'" pattern uses [^%a\\.] to avoid pairing inside words (don't → don't').
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    },
  },
}
