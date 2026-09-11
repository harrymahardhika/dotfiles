#!/usr/bin/env bash
# keyd-mods.sh — waybar custom module (continuous JSON) showing which
# modifiers are currently held/active according to keyd's oneshot layers.
# Requires the running user to be in the `keyd` group (socket access).
set -euo pipefail

command -v keyd >/dev/null 2>&1 || { echo '{"text":"","tooltip":"keyd not found"}'; exit 0; }

declare -A ICONS=(
  [shift]="⇧"
  [control]="⌃"
  [alt]="⌥"
  [meta]="⌘"
)
# Order modifiers should appear in when multiple are active
ORDER=(control alt shift meta)

declare -A ACTIVE=()

emit() {
  local text="" name
  for name in "${ORDER[@]}"; do
    [ -n "${ACTIVE[$name]:-}" ] && text+="${ICONS[$name]:-$name} "
  done
  text="${text% }"
  if [ -n "$text" ]; then
    printf '{"text":"%s","tooltip":"Active modifiers: %s","class":"active"}\n' "$text" "$text"
  else
    printf '{"text":"","tooltip":"No modifiers held","class":"idle"}\n'
  fi
}

emit

keyd listen 2>/dev/null | while IFS= read -r line; do
  case "$line" in
    +*)
      name="${line#+}"
      [ -n "${ICONS[$name]:-}" ] || continue
      ACTIVE[$name]=1
      emit
      ;;
    -*)
      name="${line#-}"
      [ -n "${ICONS[$name]:-}" ] || continue
      unset "ACTIVE[$name]"
      emit
      ;;
    /*)
      # layer context switch (e.g. /main) — ignore
      ;;
  esac
done
