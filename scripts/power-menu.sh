#!/usr/bin/env bash
# power-menu.sh — rofi confirmation menu for lock/suspend/logout/reboot/shutdown.
# Bound to SUPER+SHIFT+X (replaces the old direct-lock bind — accidental
# taps of a bare suspend/lock key no longer immediately act).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v rofi >/dev/null 2>&1 || { echo "rofi is required" >&2; exit 1; }

declare -A ACTIONS=(
	["󰌾 Lock"]="lock"
	["󰤄 Suspend"]="suspend"
	["󰍃 Logout"]="logout"
	["󰜉 Reboot"]="reboot"
	["󰐥 Shutdown"]="shutdown"
)
ORDER=("󰌾 Lock" "󰤄 Suspend" "󰍃 Logout" "󰜉 Reboot" "󰐥 Shutdown")

sel=$(printf '%s\n' "${ORDER[@]}" | rofi -dmenu -p " Power " -i -no-custom)

[ -n "$sel" ] || exit 0

case "${ACTIONS[$sel]:-}" in
	lock) exec "$HOME/.config/hypr/swaylock.sh" ;;
	suspend) exec systemctl suspend ;;
	logout) exec hyprctl dispatch exit ;;
	reboot) exec systemctl reboot ;;
	shutdown) exec systemctl poweroff ;;
	*) exit 0 ;;
esac
