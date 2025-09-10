#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"

echo "Setting wallpaper from $WALLPAPER_DIR"

if [ -d "$WALLPAPER_DIR" ]; then
    IMAGE=$(find -L "$WALLPAPER_DIR" -type f | shuf -n 1)

    # Set wallpaper with a smooth transition
    swww img "$IMAGE" \
      --transition-type any \
      --transition-fps 60 \
      --transition-duration 2
fi
