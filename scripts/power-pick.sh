#!/usr/bin/env bash
# power-pick.sh — rofi frontend for power-profiles-daemon.
# Lists available power profiles; picks one with rofi and applies it.
set -euo pipefail

command -v rofi >/dev/null 2>&1 || { echo "rofi is required" >&2; exit 1; }
command -v powerprofilesctl >/dev/null 2>&1 || { echo "powerprofilesctl is required (power-profiles-daemon)" >&2; exit 1; }

declare -A ICONS=(
	[performance]="󰓅"
	[balanced]="󰗑"
	[power-saver]="󰌪"
)

mapfile -t profiles < <(powerprofilesctl list | sed -n 's/^\*\?[[:space:]]*\([a-z-]*\):$/\1/p')

[ ${#profiles[@]} -gt 0 ] || { echo "no power profiles found" >&2; exit 1; }

current="$(powerprofilesctl get)"

labels=()
for p in "${profiles[@]}"; do
	labels+=("${ICONS[$p]:-} $p")
done

selected_row=1
for i in "${!profiles[@]}"; do
	if [ "${profiles[$i]}" = "$current" ]; then
		selected_row=$((i + 1))
		break
	fi
done

sel=$(printf '%s\n' "${labels[@]}" | rofi -dmenu -p " Power " -i -no-custom -selected-row "$selected_row")

[ -n "$sel" ] || exit 0

for i in "${!labels[@]}"; do
	if [ "${labels[$i]}" = "$sel" ]; then
		chosen="${profiles[$i]}"
		break
	fi
done

[ -n "${chosen:-}" ] || exit 0
[ "$chosen" = "$current" ] && exit 0

powerprofilesctl set "$chosen"

if command -v notify-send >/dev/null 2>&1; then
	notify-send -a "power-pick" -u normal -t 5000 "Power scheme changed" "${ICONS[$chosen]:-} $chosen" >/dev/null 2>&1 || true
fi

# Nudge the waybar custom/power_scheme module to refresh immediately.
pkill -RTMIN+8 waybar >/dev/null 2>&1 || true
