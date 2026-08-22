#!/bin/bash
STATE_FILE="${XDG_RUNTIME_DIR}/waybar-visible"

hide_bar() {
  rm -f "$STATE_FILE"
  pkill -SIGUSR1 waybar
}

case "${1:-toggle}" in
  toggle)
    if [ -f "$STATE_FILE" ]; then
      hide_bar
    else
      touch "$STATE_FILE"
      pkill -SIGUSR1 waybar
    fi
    ;;
  hide)
    hide_bar
    ;;
esac
