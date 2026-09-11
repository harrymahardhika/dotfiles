#!/usr/bin/env bash
# notif-center.sh — rofi-based notification center over mako's history.
# Lists recent (incl. expired/dismissed) notifications via `makoctl history`.
# Enter invokes the notification's default action; Alt+1 removes it from
# history. Escape/no selection exits quietly.
set -euo pipefail

command -v rofi >/dev/null 2>&1 || { echo "rofi is required" >&2; exit 1; }
command -v makoctl >/dev/null 2>&1 || { echo "makoctl (mako) is required" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 1; }

mapfile -t ROWS < <(makoctl history -j | jq -r '
  .[] | [.id, (.app_name // "?"), ((.summary // "") + " — " + (.body // ""))] | @tsv
')

if [ ${#ROWS[@]} -eq 0 ]; then
	rofi -e "No notifications"
	exit 0
fi

declare -a IDS=() LABELS=()
for row in "${ROWS[@]}"; do
	IFS=$'\t' read -r id app text <<<"$row"
	text="${text//$'\n'/ }"
	IDS+=("$id")
	LABELS+=("$(printf '%-16s %s' "$app" "$text")")
done

set +e
sel=$(printf '%s\n' "${LABELS[@]}" | rofi -dmenu -i -no-custom -p "Notifications" \
	-format i \
	-theme-str 'window {width: 1000px; height: 520px;}' \
	-theme-str 'listview {columns: 1; lines: 12;}')
status=$?
set -e

[ -n "${sel:-}" ] || exit 0
[ "$sel" -lt ${#IDS[@]} ] || exit 0

id="${IDS[$sel]}"

if [ "$status" -eq 10 ]; then
	makoctl dismiss -n "$id"
else
	makoctl invoke -n "$id" 2>/dev/null || true
fi
