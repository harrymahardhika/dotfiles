#!/usr/bin/env bash
# Prints battery icon + percentage for tmux status-right.

bat=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' -print -quit)
[ -z "$bat" ] && exit 0

capacity=$(cat "$bat/capacity")
status=$(cat "$bat/status")

if [ "$status" = "Charging" ]; then
    icon="󰂄"
elif [ "$capacity" -ge 90 ]; then
    icon="󰁹"
elif [ "$capacity" -ge 60 ]; then
    icon="󰁾"
elif [ "$capacity" -ge 40 ]; then
    icon="󰁼"
elif [ "$capacity" -ge 20 ]; then
    icon="󰁺"
else
    icon="󰂎"
fi

echo "${icon} ${capacity}%"
