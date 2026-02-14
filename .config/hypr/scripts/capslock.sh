#!/bin/bash
# Caps Lock indicator for Hyprlock

# Check if Caps Lock is on
if [[ $(xset q | grep "Caps Lock" | awk '{print $4}') == "on" ]]; then
    echo "⇪ CAPS LOCK"
else
    echo ""
fi
