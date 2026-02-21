#!/bin/bash
# Caps Lock indicator for Hyprlock

# Check if Caps Lock is on using sysfs (Wayland compatible)
if grep -q "1" /sys/class/leds/*::capslock/brightness 2>/dev/null; then
    echo "󰪛 CAPS LOCK"
else
    echo ""
fi
