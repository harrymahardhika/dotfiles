#!/usr/bin/env bash
set -euo pipefail

# Configuration
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/sway-opacity-mode"
OPACITY_SOLID=1
OPACITY_TRANSPARENT="${OPACITY_TRANSPARENT:-0.95}"

# Check dependencies
for cmd in swaymsg jq dunstify; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' not found" >&2
    exit 1
  fi
done

# Get current state (default = solid)
if [ -f "$STATE_FILE" ]; then
  state=$(<"$STATE_FILE")
else
  state="solid"
fi

# Collect window IDs, excluding special windows
# Filter: real containers with PIDs, not floating, not scratchpad
if ! tree_data=$(swaymsg -t get_tree 2>&1); then
  dunstify -u critical "Sway" "Failed to get window tree"
  exit 1
fi

# Build array of window IDs
mapfile -t ids < <(echo "$tree_data" | jq -r '
  .. | objects
  | select(
      .type? == "con"
      and .pid != null
      and .name != null
      and (.name | test("^(swaybar|waybar)") | not)
    )
  | .id
')

if [ ${#ids[@]} -eq 0 ]; then
  dunstify -u low "Sway" "No windows to toggle"
  exit 0
fi

# Toggle transparency
if [ "$state" = "solid" ]; then
  target_opacity="$OPACITY_TRANSPARENT"
  new_state="transparent"
  message="Transparency enabled (${#ids[@]} windows)"
else
  target_opacity="$OPACITY_SOLID"
  new_state="solid"
  message="Solid mode enabled (${#ids[@]} windows)"
fi

# Apply opacity changes
failed=0
for id in "${ids[@]}"; do
  if ! swaymsg "[con_id=$id] opacity $target_opacity" >/dev/null 2>&1; then
    ((failed++)) || true
  fi
done

# Update state file only if at least some windows were updated successfully
if [ $failed -lt ${#ids[@]} ]; then
  echo "$new_state" > "$STATE_FILE"
  if [ $failed -gt 0 ]; then
    dunstify -u normal "Sway" "$message (${failed} failed)"
  else
    dunstify -u low "Sway" "$message"
  fi
else
  dunstify -u critical "Sway" "Failed to change opacity for all windows"
  exit 1
fi
