#!/usr/bin/env bash
# theme-pick.sh — rofi frontend for theme-switch.sh
# Lists available themes; picks one with rofi and applies it.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command -v rofi >/dev/null 2>&1 || { echo "rofi is required" >&2; exit 1; }

themes="$("$SCRIPT_DIR/theme-switch.sh" list)"

[ -n "$themes" ] || { echo "no themes found" >&2; exit 1; }

current="$("$SCRIPT_DIR/theme-switch.sh" current)"

sel=$(echo "$themes" | rofi -dmenu -p " Theme " -i -no-custom \
  -selected-row "$(echo "$themes" | grep -n "^${current}$" | cut -d: -f1 || echo 0)")

[ -n "$sel" ] || exit 0
[ "$sel" = "$current" ] && exit 0

exec "$SCRIPT_DIR/theme-switch.sh" apply "$sel"
