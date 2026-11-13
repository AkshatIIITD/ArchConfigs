#!/usr/bin/env bash
# Random wallpaper from ~/Pictures/Wallpapers via hyprpaper IPC.
#   wallpaper.sh          switch to a new random wallpaper now (SUPER+W)
#   wallpaper.sh --loop   pick one at login, then switch every 30 min (autostart)
# Override with WALLPAPER_DIR / WALLPAPER_INTERVAL (seconds).
set -uo pipefail

dir="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
interval="${WALLPAPER_INTERVAL:-1800}"

next() {
	local current pick
	current=$(hyprctl hyprpaper listactive 2>/dev/null | head -n1 | sed 's/^[^:]*: //')
	pick=$(find "$dir" -maxdepth 1 -type f \
		\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
		! -path "$current" | shuf -n1)
	[[ -n "$pick" ]] && hyprctl hyprpaper wallpaper ",$pick" >/dev/null
}

if [[ "${1:-}" == "--loop" ]]; then
	# Only one loop at a time (e.g. after a Hyprland reload)
	exec 9>"${XDG_RUNTIME_DIR:-/tmp}/wallpaper-loop.lock"
	flock -n 9 || exit 0
	sleep 2 # give hyprpaper time to start at login
	next
	while sleep "$interval"; do next; done
else
	next
fi
