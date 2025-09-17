#!/usr/bin/env bash

STATE_FILE="/tmp/sway-opacity-mode"
OPACITY_SOLID=1
OPACITY_TRANSPARENT=0.96

if [ -f "$STATE_FILE" ]; then
  state=$(<"$STATE_FILE")
else
  state="solid"
fi

if [ "$state" = "solid" ]; then
  swaymsg 'for_window [app_id=".*"] opacity '"$OPACITY_TRANSPARENT" >/dev/null
  swaymsg 'opacity '"$OPACITY_TRANSPARENT" >/dev/null
  echo "transparent" > "$STATE_FILE"
else
  swaymsg 'for_window [app_id=".*"] opacity '"$OPACITY_SOLID" >/dev/null
  swaymsg 'opacity '"$OPACITY_SOLID" >/dev/null
  echo "solid" > "$STATE_FILE"
fi
