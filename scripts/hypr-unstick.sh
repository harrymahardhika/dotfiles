#!/usr/bin/env bash
# hypr-unstick.sh — detect and clear a lock-session race (formerly hyprlock's
# "onLockFinished called. Seems we got yeeten."; swaylock is used now but the
# same class of race is checked for) where the locker loses its lock surface
# (commonly on suspend/resume) but Hyprland still thinks the session is
# locked, leaving the built-in crashed-lockscreen fallback painted on screen
# with no way to unlock normally.
#
# Safe to run unconditionally after resume: it's a no-op unless Hyprland's
# session-lock state is actually stuck.
#
# See: [[aquamarine-i915-suspend-crash]] for the related (separate)
# aquamarine DRM segfault this does NOT fix.
set -uo pipefail

command -v hyprctl >/dev/null 2>&1 || exit 0

log() { echo "[hypr-unstick] $*" >&2; }

# Don't trust an inherited HYPRLAND_INSTANCE_SIGNATURE — it can be stale
# (e.g. from a shell started before a compositor restart). `--instance 0`
# targets whatever Hyprland instance is actually live, which is simpler and
# confirmed working here (single-instance is the normal case on this machine).
try_clear() {
  hyprctl --instance 0 eval 'hl.clear_crashed_lockscreen()' 2>&1
}

result="$(try_clear)"

if echo "$result" | grep -q "session is not locked"; then
  # Nothing stuck — normal path, exit quietly.
  exit 0
fi

if echo "$result" | grep -qi "^ok\|^$"; then
  log "cleared a stuck crashed-lockscreen state"
else
  log "clear_crashed_lockscreen returned: $result"
fi

# A stuck lock is usually paired with a zombie lock process that still holds
# the old (now-invalid) lock surface. Terminate it gracefully; hypridle's
# own lock_cmd/before_sleep_cmd will start a fresh one next time it's needed.
# Check both swaylock (current) and hyprlock (former, kept as a fallback).
for locker in swaylock hyprlock; do
  if pgrep -x "$locker" >/dev/null 2>&1; then
    log "terminating stale $locker process(es)"
    pkill -x "$locker" 2>/dev/null
    sleep 0.3
    pgrep -x "$locker" >/dev/null 2>&1 && pkill -9 -x "$locker" 2>/dev/null
  fi
done

# Force a full re-composite so the stale scanout buffer (the frozen
# crashed-lockscreen image) is replaced with a fresh frame.
hyprctl --instance 0 reload >/dev/null 2>&1
log "done"
