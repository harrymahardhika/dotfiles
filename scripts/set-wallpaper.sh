#!/usr/bin/env bash

# Directory where wallpapers are stored
THEME_STATE="$HOME/.cache/theme-current"
THEME="mocha"

if [ -f "$THEME_STATE" ]; then
  THEME=$(cat "$THEME_STATE")
fi

WALLPAPER_DIR="$HOME/wallpapers/$THEME"

if [ ! -d "$WALLPAPER_DIR" ]; then
  WALLPAPER_DIR="$HOME/wallpapers"
fi

# Check if the directory exists and contains images
if [ -d "$WALLPAPER_DIR" ]; then
  # Set the random image as wallpaper using feh
  feh --bg-scale --randomize "$WALLPAPER_DIR"
fi
