#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"

echo "Setting wallpaper from $WALLPAPER_DIR"

if [ ! -d "$WALLPAPER_DIR" ]; then
  exit 0
fi

WALLPAPER_PATH=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

if [ -z "$WALLPAPER_PATH" ]; then
  exit 0
fi

pkill hyprpaper >/dev/null 2>&1 || true

if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  swww-daemon >/dev/null 2>&1 &
  sleep 0.2
fi

MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

if [ -n "$MONITORS" ]; then
  for MON in $MONITORS; do
    swww img -o "$MON" "$WALLPAPER_PATH" --transition-type any --transition-fps 60 --transition-duration 1 >/dev/null 2>&1
  done
else
  swww img "$WALLPAPER_PATH" --transition-type any --transition-fps 60 --transition-duration 1 >/dev/null 2>&1
fi
