#!/usr/bin/env bash

# Directory where wallpapers are stored
WALLPAPER_DIR="$HOME/wallpapers"

# Check if the directory exists and contains images
if [ -d "$WALLPAPER_DIR" ]; then
  # Set the random image as wallpaper using feh
  feh --bg-scale --randomize "$WALLPAPER_DIR"
fi

