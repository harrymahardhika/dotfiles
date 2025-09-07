#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"
HYPERPAPER_CONF="/tmp/hyprpaper.conf"

echo "Setting wallpaper from $WALLPAPER_DIR"

if [ -d "$WALLPAPER_DIR" ] && find -L "$WALLPAPER_DIR" -type f | grep -q .; then
  WALLPAPER_PATH=$(find -L "$WALLPAPER_DIR" -type f | shuf -n 1)

  # Kill existing hyprpaper instances
  pkill hyprpaper

  # Create a temporary Hyprpaper config
  echo "preload = $WALLPAPER_PATH" > "$HYPERPAPER_CONF"

  # Set for each monitor (you can customize or detect dynamically)
  for MON in $(hyprctl monitors -j | jq -r '.[].name'); do
    echo "wallpaper = $MON,$WALLPAPER_PATH" >> "$HYPERPAPER_CONF"
  done

  # Start hyprpaper with the config
  hyprpaper -c "$HYPERPAPER_CONF" &
fi

