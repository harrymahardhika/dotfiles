#!/usr/bin/env bash
set -uo pipefail

STATE_FILE="/tmp/hypr-transparent"

if [ -f "$STATE_FILE" ]; then
  echo 'hl.config({ decoration = { active_opacity = 1.0, inactive_opacity = 0.95 } })' > /tmp/hypr-opacity.lua
  rm -f "$STATE_FILE"
else
  echo 'hl.config({ decoration = { active_opacity = 0.97, inactive_opacity = 0.75 } })' > /tmp/hypr-opacity.lua
  touch "$STATE_FILE"
fi

hyprctl reload
