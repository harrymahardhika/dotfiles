#!/bin/bash

i3-msg -t subscribe '[ "window" ]' | \
while read -r line; do
  focused=$(echo "$line" | jq -r '.container.focused')
  if [ "$focused" = "true" ]; then
    winid=$(echo "$line" | jq -r '.container.window')

    # Skip invalid or empty window IDs
    if [ "$winid" = "0" ] || [ -z "$winid" ]; then
      continue
    fi

    # Debug info
    echo "Focused X11 window ID: $winid" >&2

    # Check if window exists
    if xdotool getwindowname "$winid" >/dev/null 2>&1; then
      # Get window geometry
      eval "$(xdotool getwindowgeometry --shell "$winid")"
      xpos=$((X + WIDTH / 2))
      ypos=$((Y + HEIGHT / 2))

      echo "Moving pointer to $xpos, $ypos" >&2
      xdotool mousemove --sync "$xpos" "$ypos"
    else
      echo "Window $winid invalid" >&2
    fi
  fi
done
