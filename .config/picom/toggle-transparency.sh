#!/bin/bash

PICOM_SOLID_CONF="$HOME/.config/picom/picom-solid.conf"
PICOM_TRANSPARENT_CONF="$HOME/.config/picom/picom.conf"
PID_FILE="/tmp/picom_transparent"
LOG_FILE="$HOME/.cache/picom.log"

stop_picom() {
  pkill -TERM -x picom
  local count=0
  while pgrep -x picom >/dev/null; do
    sleep 0.5
    count=$((count + 1))
    if [ $count -ge 10 ]; then
      echo "$(date): Timeout waiting for picom to stop" >> "$LOG_FILE"
      break
    fi
  done
}

start_picom() {
  nohup picom --config "$1" &>> "$LOG_FILE" &
  echo "$(date): Started picom with $1" >> "$LOG_FILE"
}

if [ -f "$PID_FILE" ]; then
  rm "$PID_FILE"
  stop_picom
  start_picom "$PICOM_SOLID_CONF"
  notify-send "Picom" "Switched to solid mode (no transparency)"
else
  touch "$PID_FILE"
  stop_picom
  start_picom "$PICOM_TRANSPARENT_CONF"
  notify-send "Picom" "Switched to transparent mode"
fi
