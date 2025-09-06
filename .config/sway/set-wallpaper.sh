#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"

echo "Setting wallpaper from $WALLPAPER_DIR"

if [ -d "$WALLPAPER_DIR" ] && find -L "$WALLPAPER_DIR" -type f | grep -q .; then
  WALLPAPER_PATH=$(find -L "$WALLPAPER_DIR" -type f | shuf -n 1)
  pkill swaybg
  swaybg -i "$WALLPAPER_PATH" -m fill &
fi
