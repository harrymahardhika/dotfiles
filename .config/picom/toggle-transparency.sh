#!/bin/bash

PICOM_SOLID_CONF="$HOME/.config/picom/picom-solid.conf"
PICOM_TRANSPARENT_CONF="$HOME/.config/picom/picom.conf"
PID_FILE="/tmp/picom_transparent"
LOG_FILE="$HOME/.cache/picom.log"

stop_picom() {
  pkill -TERM -x picom
  # Wait until picom fully exits
  while pgrep -x picom >/dev/null; do sleep 0.1; done
}

start_picom() {
  picom --config "$1" &> "$LOG_FILE" &
}

if [ -f "$PID_FILE" ]; then
  rm "$PID_FILE"
  stop_picom
  start_picom "$PICOM_SOLID_CONF"
else
  touch "$PID_FILE"
  stop_picom
  start_picom "$PICOM_TRANSPARENT_CONF"
fi
