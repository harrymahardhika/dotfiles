#!/usr/bin/env bash
set -uo pipefail

STATE_FILE="/tmp/hypr-transparent"

if [ -f "$STATE_FILE" ]; then
  echo 'hl.config({ decoration = { active_opacity = 1.0, inactive_opacity = 1.0 }, general = { border_size = 1, ["col.active_border"] = "rgb(938056)", ["col.inactive_border"] = "rgb(1f1f28)" } })' > /tmp/hypr-opacity.lua
  rm -f "$STATE_FILE"
else
  echo 'hl.config({ decoration = { active_opacity = 0.95, inactive_opacity = 0.85 }, general = { border_size = 0 } })' > /tmp/hypr-opacity.lua
  touch "$STATE_FILE"
fi

hyprctl reload
