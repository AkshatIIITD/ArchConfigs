-- lua/lualine/themes/desktop.lua
-- Accent mode block, surface middle, bg elsewhere (lua/config/palette.lua).

local c = require("config.palette")

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
