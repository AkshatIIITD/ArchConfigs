-- colors/desktop.lua
-- Palette from lua/config/palette.lua (shared with tmux, starship, fastfetch).
-- Do not add colours outside the palette.

local c = require("config.palette")

vim.cmd("highlight clear")
vim.g.colors_name = "desktop"
vim.o.background = "dark"

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

-- ── editor ───────────────────────────────────────────────────────────────────
hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalNC", { link = "Normal" })
hl("NormalFloat", { fg = c.fg, bg = c.bg })
hl("FloatBorder", { fg = c.accent, bg = c.bg })
hl("FloatTitle", { fg = c.accent, bg = c.bg, bold = true })
hl("WinSeparator", { fg = c.surface })
hl("EndOfBuffer", { fg = c.bg })
hl("SignColumn", { bg = c.bg })
hl("LineNr", { fg = c.muted })
hl("CursorLineNr", { fg = c.accent, bold = true })
hl("CursorLine", { bg = c.surface })
hl("ColorColumn", { bg = c.surface })
-- Accent block like kitty/tmux selection; surface would vanish on CursorLine
hl("Visual", { fg = c.bg, bg = c.accent })
hl("Search", { fg = c.bg, bg = c.accent })
hl("IncSearch", { fg = c.bg, bg = c.warn })
hl("CurSearch", { link = "IncSearch" })
hl("MatchParen", { fg = c.accent, bold = true, underline = true })
hl("Folded", { fg = c.muted, bg = c.surface })
hl("NonText", { fg = c.surface })
hl("Whitespace", { fg = c.surface })
hl("Directory", { fg = c.accent })
hl("Title", { fg = c.accent, bold = true })
hl("Conceal", { fg = c.muted })
hl("QuickFixLine", { bg = c.surface })

hl("StatusLine", { fg = c.fg, bg = c.surface })
hl("StatusLineNC", { fg = c.muted, bg = c.bg })
hl("TabLine", { fg = c.muted, bg = c.surface })
hl("TabLineSel", { fg = c.bg, bg = c.accent })
hl("TabLineFill", { bg = c.bg })
hl("WinBar", { fg = c.fg, bg = c.bg })
hl("WinBarNC", { fg = c.muted, bg = c.bg })

hl("Pmenu", { fg = c.fg, bg = c.bg })
hl("PmenuSel", { fg = c.bg, bg = c.accent })
hl("PmenuSbar", { bg = c.surface })
hl("PmenuThumb", { bg = c.muted })

hl("ErrorMsg", { fg = c.crit })
hl("WarningMsg", { fg = c.warn })
hl("MoreMsg", { fg = c.accent })
hl("ModeMsg", { fg = c.accent })
hl("Question", { fg = c.accent })

-- ── syntax (minimal: cyan structure, white text, muted comments) ─────────────
hl("Comment", { fg = c.muted, italic = true })
hl("Constant", { fg = c.fg })
hl("String", { fg = c.fg })
hl("Number", { fg = c.fg })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.accent })
hl("Statement", { fg = c.accent })
hl("Operator", { fg = c.muted })
hl("PreProc", { fg = c.accent })
hl("Type", { fg = c.fg, bold = true })
hl("Special", { fg = c.accent })
hl("Delimiter", { fg = c.muted })
hl("Underlined", { underline = true })
hl("Error", { fg = c.crit })
hl("Todo", { fg = c.bg, bg = c.warn, bold = true })

-- ── diagnostics ──────────────────────────────────────────────────────────────
hl("DiagnosticError", { fg = c.crit })
hl("DiagnosticWarn", { fg = c.warn })
hl("DiagnosticInfo", { fg = c.accent })
hl("DiagnosticHint", { fg = c.muted })
hl("DiagnosticOk", { fg = c.accent })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.crit })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.accent })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.muted })
hl("LspInlayHint", { fg = c.muted, italic = true })
hl("LspReferenceText", { bg = c.surface })
hl("LspReferenceRead", { bg = c.surface })
hl("LspReferenceWrite", { bg = c.surface, underline = true })
hl("LspCodeLens", { fg = c.muted })

-- ── diff and git ─────────────────────────────────────────────────────────────
hl("Added", { fg = c.accent })
hl("Changed", { fg = c.warn })
hl("Removed", { fg = c.crit })
hl("DiffAdd", { fg = c.accent, bg = c.surface })
hl("DiffChange", { bg = c.surface })
hl("DiffDelete", { fg = c.crit })
hl("DiffText", { fg = c.warn, bg = c.surface, bold = true })
hl("GitSignsAdd", { fg = c.accent })
hl("GitSignsChange", { fg = c.warn })
hl("GitSignsDelete", { fg = c.crit })

-- ── plugins ──────────────────────────────────────────────────────────────────
hl("IblIndent", { fg = c.surface })
hl("IblScope", { fg = c.muted })

hl("TelescopeNormal", { link = "NormalFloat" })
hl("TelescopeBorder", { link = "FloatBorder" })
hl("TelescopePromptPrefix", { fg = c.accent })
hl("TelescopeSelection", { bg = c.surface })
hl("TelescopeMatching", { fg = c.accent, bold = true })

hl("BlinkCmpMenu", { link = "Pmenu" })
hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
hl("BlinkCmpMenuSelection", { link = "PmenuSel" })
hl("BlinkCmpLabelMatch", { fg = c.accent, bold = true })
hl("BlinkCmpGhostText", { fg = c.muted })

hl("WhichKey", { fg = c.accent })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeyGroup", { fg = c.muted })
hl("WhichKeySeparator", { fg = c.muted })

hl("OilDir", { fg = c.accent })
hl("OilDirIcon", { fg = c.accent })

hl("RenderMarkdownCode", { bg = c.surface })
hl("RenderMarkdownH1Bg", { fg = c.accent, bg = c.surface })
hl("RenderMarkdownH2Bg", { fg = c.accent, bg = c.surface })
hl("RenderMarkdownH3Bg", { fg = c.accent, bg = c.surface })
hl("RenderMarkdownH4Bg", { fg = c.accent, bg = c.surface })
hl("RenderMarkdownH5Bg", { fg = c.accent, bg = c.surface })
hl("RenderMarkdownH6Bg", { fg = c.accent, bg = c.surface })

-- ── treesitter links to the groups above ─────────────────────────────────────
hl("@variable", { fg = c.fg })
hl("@property", { fg = c.fg })
hl("@punctuation", { link = "Delimiter" })
hl("@tag", { fg = c.accent })
hl("@tag.attribute", { fg = c.fg })
hl("@markup.heading", { fg = c.accent, bold = true })
hl("@markup.link", { fg = c.accent, underline = true })
hl("@markup.raw", { fg = c.muted })

-- ── terminal colours (:terminal) ─────────────────────────────────────────────
vim.g.terminal_color_0 = c.bg
vim.g.terminal_color_1 = c.crit
vim.g.terminal_color_2 = c.accent
vim.g.terminal_color_3 = c.warn
vim.g.terminal_color_4 = c.accent
vim.g.terminal_color_5 = c.muted
vim.g.terminal_color_6 = c.accent
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.surface
vim.g.terminal_color_9 = c.crit
vim.g.terminal_color_10 = c.accent
vim.g.terminal_color_11 = c.warn
vim.g.terminal_color_12 = c.accent
vim.g.terminal_color_13 = c.muted
vim.g.terminal_color_14 = c.accent
vim.g.terminal_color_15 = c.fg
