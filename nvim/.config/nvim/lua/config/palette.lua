-- lua/config/palette.lua
-- Theme colours shared with tmux, starship and fastfetch (see ~/.config/theme).
-- Order: built-in desktop values < palettes/desktop.sh < this machine's choice
-- (~/.local/state/theme/palette.sh, written by ~/.config/theme/apply).

local home = vim.env.HOME

-- Last resort if the theme package is not stowed: same as palettes/desktop.sh
local c = {
  bg = "#0f0f0f",
  surface = "#333333",
  fg = "#ffffff",
  muted = "#888888",
  accent = "#00ffff",
  warn = "#ffaa00",
  crit = "#ff3333",
}

-- Read THEME_KEY="#rrggbb" lines; anything else is ignored
local function load(path)
  local f = io.open(path, "r")
  if not f then
    return
  end
  for line in f:lines() do
    local key, value = line:match('^THEME_(%u+)="(#%x%x%x%x%x%x)"')
    if key and c[key:lower()] then
      c[key:lower()] = value
    end
  end
  f:close()
end

load(home .. "/.config/theme/palettes/desktop.sh")
load(home .. "/.local/state/theme/palette.sh")

return c
