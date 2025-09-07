#!/usr/bin/env bash
set -euo pipefail

get_active() {
  hyprctl getoption decoration:active_opacity | awk '/float/ {print $NF}'
}

ACTIVE="$(get_active)"
OPAQUE=$(awk -v v="$ACTIVE" 'BEGIN{if (v>=0.999) print "yes"; else print "no";}')

if [[ "$OPAQUE" == "yes" ]]; then
  # Make windows semi-transparent
  hyprctl keyword decoration:active_opacity 0.97
  hyprctl keyword decoration:inactive_opacity 0.86
else
  # Restore full opacity
  hyprctl keyword decoration:active_opacity 1.0
  hyprctl keyword decoration:inactive_opacity 1.0
fi

