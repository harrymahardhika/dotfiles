#!/usr/bin/env bash

# Directory where wallpapers are stored
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Check if the directory exists and contains images
if [ -d "$WALLPAPER_DIR" ]; then
  # Create an array of all jpg, jpeg, and png images in the directory
  #wallpapers=("$WALLPAPER_DIR"/*.{jpg,jpeg,png})
  wallpapers=("$WALLPAPER_DIR"/*.jpeg)

    # Check if the array has any valid images
    if [ ${#wallpapers[@]} -gt 0 ]; then
      # Pick a random wallpaper from the array
      RANDOM_WALLPAPER="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

        # Set the random image as wallpaper using feh
        feh --bg-scale "$RANDOM_WALLPAPER"
    fi
fi

