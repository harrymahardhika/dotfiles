#!/usr/bin/env bash
# waybar-style.sh — toggle waybar between pills and flat style.
#
# Usage:
#   waybar-style.sh          # toggle
#   waybar-style.sh pills    # force pills
#   waybar-style.sh flat     # force flat
#   waybar-style.sh current  # print current style
set -euo pipefail

WAYBAR_DIR="$HOME/.config/waybar"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-style"
STYLE_CSS="$WAYBAR_DIR/style.css"
PILLS_CSS="$WAYBAR_DIR/style-pills.css"
FLAT_CSS="$WAYBAR_DIR/style-flat.css"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-style.lock"

# Opt-in debug trace: WAYBAR_STYLE_DEBUG=1 waybar-style.sh ... (writes /tmp log)
debug() {
  [ -n "${WAYBAR_STYLE_DEBUG:-}" ] || return 0
  echo "$(date '+%F %T') $*" >> /tmp/waybar-style.log
}

# serialize: a restart in flight takes ~1s to reach "Bar configured"; a
# second press landing mid-restart kills that process before it ever draws,
# which is what leaves the bar missing until another press. Queue instead.
exec 9>"$LOCK_FILE"
flock 9

current_theme() {
  cat "$HOME/.cache/theme-current" 2>/dev/null || echo "mocha"
}

detect_style() {
  # prefer the persisted state (set by apply_style) — content-sniffing the
  # CSS is fragile since per-module rules (e.g. an idle-collapse rule) can
  # legitimately contain "margin: 0;" in the pills variant too
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
    return
  fi
  if [ ! -f "$STYLE_CSS" ]; then
    echo "pills"
    return
  fi
  # fallback heuristic: only the pills variant gives modules their pill
  # spacing (margin: 0.15rem in the base rule); flat always uses margin: 0
  if grep -q 'margin: 0\.15rem;' "$STYLE_CSS" 2>/dev/null; then
    echo "pills"
  else
    echo "flat"
  fi
}

apply_style() {
  local target="$1"
  local src
  case "$target" in
    pills) src="$PILLS_CSS" ;;
    flat)  src="$FLAT_CSS" ;;
    *)     echo "waybar-style: unknown style '$target'" >&2; exit 1 ;;
  esac

  [ -f "$src" ] || { echo "waybar-style: $src not found" >&2; exit 1; }

  cp "$src" "$STYLE_CSS"

  # fix @import to match the active theme
  local theme
  theme="$(current_theme)"
  sed -i "s|@import \"[^\"]*\"|@import \"$theme.css\"|" "$STYLE_CSS"

  # persist choice
  echo "$target" > "$STATE_FILE"

  # waybar's live CSS watcher only picks up cosmetic changes; structural
  # changes (margin/border-radius/module grouping) need a real restart
  systemctl --user restart waybar.service
  # give the new process a moment to finish drawing before releasing the
  # lock, so a queued second press restarts a running bar instead of a
  # mid-startup one (systemd reports "active" well before the bar surface is up)
  sleep 0.6
  debug "waybar style: $target"
}

cmd="${1:-toggle}"
debug "called with '$cmd' from PID $$"
case "$cmd" in
  toggle)
    current="$(detect_style)"
    if [ "$current" = "pills" ]; then
      apply_style flat
    else
      apply_style pills
    fi
    ;;
  pills|flat)
    apply_style "$cmd"
    ;;
  current)
    detect_style
    ;;
  *)
    echo "Usage: waybar-style.sh [toggle|pills|flat|current]" >&2
    exit 1
    ;;
esac
