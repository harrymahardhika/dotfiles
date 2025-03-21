#!/bin/bash

# Set the battery threshold for warnings
LOW_BATTERY=15
CRITICAL_BATTERY=5

# Get battery percentage
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Notify user if battery is low and not charging
if [[ "$BATTERY_STATUS" != "Charging" ]]; then
    if [[ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ]]; then
        notify-send -u critical "⚠ Critical Battery" "Battery is at ${BATTERY_LEVEL}%. Plug in your charger!"
        paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga  # Play warning sound
    elif [[ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ]]; then
        notify-send -u normal "⚠ Low Battery" "Battery is at ${BATTERY_LEVEL}%. Consider plugging in."
    fi
fi

