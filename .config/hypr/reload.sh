#!/bin/bash

hyprctl reload >/dev/null 2>&1
killall waybar >/dev/null 2>&1 && waybar >/dev/null 2>&1 &
killall hyprpaper >/dev/null 2>&1 && hyprpaper >/dev/null 2>&1 &

