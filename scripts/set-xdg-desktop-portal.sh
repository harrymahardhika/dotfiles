#!/usr/bin/env bash
set -euo pipefail

LOGFILE="$HOME/.local/share/portal-switch.log"
mkdir -p "$(dirname "$LOGFILE")"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"; }

stop_portals() {
  log "Stopping existing xdg-desktop-portal services"
  
  # Only clean up runtime directory - skip process killing as it hangs
  rm -rf "/run/user/$UID/xdg-desktop-portal" 2>/dev/null || true
  
  log "Portal cleanup completed"
}

start_portals() {
  local mode="$1"

  case "$mode" in
    x11)    export XDG_CURRENT_DESKTOP=GNOME; log "X11 → GTK backend";;
    wayland)export XDG_CURRENT_DESKTOP=sway;  log "Wayland → WLR backend";;
  esac

  # propagate env to user manager
  systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DISPLAY WAYLAND_DISPLAY

  if [ "$mode" = "x11" ]; then
    systemctl --user --no-block start xdg-desktop-portal-gtk.service
  else
    systemctl --user --no-block start xdg-desktop-portal-wlr.service
  fi
  systemctl --user --no-block start xdg-desktop-portal.service
  log "Requested start of xdg-desktop-portal (+ backend: $mode)"

  # self-check (gives the backend time to register on the bus)
  sleep 1
  if [ "$mode" = "x11" ]; then
    if timeout 3 busctl --user --timeout=2 status org.freedesktop.impl.portal.desktop.gtk >/dev/null 2>&1; then
      log "OK: gtk portal active"
    else
      log "WARN: gtk portal NOT active"
    fi
  else
    if timeout 3 busctl --user --timeout=2 status org.freedesktop.impl.portal.desktop.wlr >/dev/null 2>&1; then
      log "OK: wlr portal active"
    else
      log "WARN: wlr portal NOT active"
    fi
  fi
}

detect_session() {
  [ "${XDG_SESSION_TYPE:-}" = "x11" ] && { echo x11; return; }
  [ "${XDG_SESSION_TYPE:-}" = "wayland" ] && { echo wayland; return; }
  [ -n "${WAYLAND_DISPLAY:-}" ] && { echo wayland; return; }
  [ -n "${DISPLAY:-}" ] && { echo x11; return; }
  [ -n "${XDG_SESSION_ID:-}" ] && {
    t=$(loginctl show-session "$XDG_SESSION_ID" -p Type --value 2>/dev/null || true)
    [ "$t" = "wayland" ] && { echo wayland; return; }
    [ "$t" = "x11" ] && { echo x11; return; }
  }
  echo wayland
}

mode=$(detect_session)
stop_portals
start_portals "$mode"

