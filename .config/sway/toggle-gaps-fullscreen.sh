#!/bin/bash
# Toggle fullscreen and gaps together

# Toggle fullscreen
swaymsg fullscreen toggle

# Check if we're now in fullscreen
FULLSCREEN=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .fullscreen_mode')

if [ "$FULLSCREEN" == "1" ]; then
    # Fullscreen enabled - remove gaps
    swaymsg gaps inner current set 0
    swaymsg gaps outer current set 0
else
    # Fullscreen disabled - restore gaps
    swaymsg gaps inner current set 2
    swaymsg gaps outer current set 0
fi
