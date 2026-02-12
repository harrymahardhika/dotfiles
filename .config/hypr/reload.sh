#!/bin/bash

hyprctl reload >/dev/null 2>&1
killall waybar >/dev/null 2>&1 && waybar >/dev/null 2>&1 &
killall hyprpaper >/dev/null 2>&1 || true
pgrep -x swww-daemon >/dev/null 2>&1 || swww-daemon --format xrgb >/dev/null 2>&1 &
"$HOME/.config/hypr/set-wallpaper.sh" >/dev/null 2>&1 &
