#!/usr/bin/env bash
# power-scheme.sh — waybar custom module showing the active power-profiles-daemon scheme.
# Refreshed on interval and on demand via `pkill -RTMIN+8 waybar` (see power-pick.sh).
set -euo pipefail

command -v powerprofilesctl >/dev/null 2>&1 || { echo '{"text":"","tooltip":"power-profiles-daemon not found"}'; exit 0; }

declare -A ICONS=(
	[performance]="󰓅"
	[balanced]="󰗑"
	[power-saver]="󰌪"
)

current="$(powerprofilesctl get 2>/dev/null || echo "")"
[ -n "$current" ] || { echo '{"text":"","tooltip":"power-profiles-daemon unavailable"}'; exit 0; }

printf '{"text":"%s %s","tooltip":"Power scheme: %s","class":"%s"}\n' \
	"${ICONS[$current]:-}" "$current" "$current" "$current"
