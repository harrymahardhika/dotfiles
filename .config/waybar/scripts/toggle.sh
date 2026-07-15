#!/bin/bash
STATE_FILE="${XDG_RUNTIME_DIR}/waybar-visible"
PID_FILE="${XDG_RUNTIME_DIR}/waybar-autohide.pid"
LOCK_FILE="${XDG_RUNTIME_DIR}/waybar-toggle.lock"
AUTO_HIDE_DELAY=8

kill_watchdog() {
  if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
  fi
}

show() {
  kill_watchdog
  touch "$STATE_FILE"
  pkill -SIGUSR1 waybar
  (
    exec 200>&- 2>/dev/null
    sleep "$AUTO_HIDE_DELAY"
    flock "$LOCK_FILE" bash -c '
      [ -f "$1" ] && { rm -f "$1"; pkill -SIGUSR1 waybar; }
      rm -f "$2"
    ' _ "$STATE_FILE" "$PID_FILE"
  ) &
  echo $! > "$PID_FILE"
}

hide() {
  kill_watchdog
  if [ -f "$STATE_FILE" ]; then
    rm -f "$STATE_FILE"
    pkill -SIGUSR1 waybar
  fi
}

{
  flock 200
  case "${1:-toggle}" in
    toggle)
      if [ -f "$STATE_FILE" ]; then
        hide
      else
        show
      fi
      ;;
    hide)
      hide
      ;;
  esac
} 200>"$LOCK_FILE"
