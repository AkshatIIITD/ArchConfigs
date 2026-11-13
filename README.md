First clone this repository, then run this command in the base folder of the repo:

```
stow -t ~ anyrun fastfetch hypr kitty mako swayosd waybar misc nvim
```

Note that for neovim, install tree-sitter-cli and base-devel

## Hyprland packages

The Hyprland config (`hypr/.config/hypr/hyprland.lua`) also expects:

- `brightnessctl` for the idle dim step in hypridle
- `hyprshutdown` for a graceful exit, used by the exit bind and the waybar power buttons (logout/reboot/shutdown)
- `anyrun` as the launcher
- `grim`, `slurp`, `wl-clipboard`, `hyprpicker`, `playerctl`, `swayosd`

## Wallpapers

Wallpaper images are not stored in this repo. Put them in `~/Pictures/Wallpapers`
(png, jpg, jpeg or webp). hyprpaper shows one at login, `scripts/wallpaper.sh`
switches to a random one every 30 minutes, and SUPER + W switches immediately.

## Keybinds

SUPER is the main modifier. Keep this table in sync with `hyprland.lua`.

### Apps
| Keys | Action |
|---|---|
| SUPER + T | Terminal (kitty) |
| SUPER + F | File manager (nemo) |
| SUPER + B | Browser (chromium) |
| SUPER + N | Notion (chromium app window) |
| SUPER + SPACE | Launcher (anyrun) |
| Print | Screenshot a region to the clipboard |
| SUPER + SHIFT + C | Colour picker (hyprpicker) |
| SUPER + W | Next random wallpaper |

### Windows
| Keys | Action |
|---|---|
| SUPER + Q | Close window |
| SUPER + M | Toggle fullscreen |
| SUPER + V | Toggle floating |
| SUPER + P | Pseudo-tile |
| SUPER + J | Toggle split direction (dwindle) |
| SUPER + Arrow keys | Move focus |
| SUPER + Left drag | Move window |
| SUPER + Right drag | Resize window |

### Workspaces
| Keys | Action |
|---|---|
| SUPER + 1–9, 0 | Go to workspace 1–10 |
| SUPER + SHIFT + 1–9, 0 | Move window to workspace 1–10 |
| SUPER + S | Show/hide the scratchpad |
| SUPER + SHIFT + S | Move window to the scratchpad |
| SUPER + Scroll | Next/previous existing workspace |
| 3-finger swipe (horizontal) | Switch workspace |

### Session
| Keys | Action |
|---|---|
| SUPER + L | Lock screen |
| SUPER + SHIFT + CTRL + Q | Exit Hyprland |

### Notifications
| Keys | Action |
|---|---|
| SUPER + ESCAPE | Dismiss the top notification |
| SUPER + SHIFT + ESCAPE | Toggle do-not-disturb (critical notifications still show) |

### Media keys (also work while locked)
| Keys | Action |
|---|---|
| Volume Up / Down | Volume ±, capped at 100%; hold to repeat |
| Mute / Mic Mute | Toggle output / input mute |
| Brightness Up / Down | Brightness ±; hold to repeat |
| Play / Pause | Play/pause |
| Next / Prev | Next / previous track |
