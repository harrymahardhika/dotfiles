#!/bin/bash
STATE_FILE="${XDG_RUNTIME_DIR}/waybar-visible"
AUTO_HIDE_DELAY=8

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
      (sleep "$AUTO_HIDE_DELAY"; [ -f "$STATE_FILE" ] && hide_bar) &
    fi
    ;;
  hide)
    hide_bar
    ;;
esac
