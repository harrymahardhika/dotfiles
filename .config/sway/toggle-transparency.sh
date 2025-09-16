#!/usr/bin/env bash

STATE_FILE="/tmp/sway-opacity-mode"
OPACITY_SOLID=1
OPACITY_TRANSPARENT=0.96

# Collect all real window IDs
ids=$(swaymsg -t get_tree | jq -r '.. | objects | select(.type? == "con" and .pid != null) | .id')

if [ -z "$ids" ]; then
  dunstify -u low "Sway" "No windows to toggle"
  exit 0
fi

# Read last state (default = solid)
if [ -f "$STATE_FILE" ]; then
  state=$(<"$STATE_FILE")
else
  state="solid"
fi

if [ "$state" = "solid" ]; then
  for id in $ids; do
    swaymsg "[con_id=$id] opacity $OPACITY_TRANSPARENT" >/dev/null
  done
  echo "transparent" > "$STATE_FILE"
  dunstify -u low "Sway" "Transparency enabled"
else
  for id in $ids; do
    swaymsg "[con_id=$id] opacity $OPACITY_SOLID" >/dev/null
  done
  echo "solid" > "$STATE_FILE"
  dunstify -u low "Sway" "Solid mode enabled"
fi
