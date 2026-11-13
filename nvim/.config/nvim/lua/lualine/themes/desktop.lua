-- lua/lualine/themes/desktop.lua
-- Desktop palette: cyan mode block, #333333 middle, bg elsewhere.

local c = {
  bg = "#0f0f0f",
  fg = "#ffffff",
  accent = "#00ffff",
  muted = "#888888",
  surface = "#333333",
  warn = "#ffaa00",
  crit = "#ff3333",
}

local function mode(color)
  return {
    a = { fg = c.bg, bg = color, gui = "bold" },
    b = { fg = c.fg, bg = c.surface },
    c = { fg = c.fg, bg = c.bg },
  }
end

return {
  normal = mode(c.accent),
  insert = mode(c.fg),
  visual = mode(c.warn),
  replace = mode(c.crit),
  command = mode(c.muted),
  inactive = {
    a = { fg = c.muted, bg = c.bg },
    b = { fg = c.muted, bg = c.bg },
    c = { fg = c.muted, bg = c.bg },
  },
}
