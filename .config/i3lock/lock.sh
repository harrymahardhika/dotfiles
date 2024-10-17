#!/bin/bash

# Set the image path
IMAGE="$HOME/wallpapers/wallpaper-11.png"

# Get screen resolution (assumes single monitor setup)
SCREEN_RES=$(xrandr | grep '*' | awk '{print $1}')

# Create a temporary image that fits the screen
TMPBG='/tmp/screen.png'
convert "$IMAGE" -resize "$SCREEN_RES^" -gravity center -extent "$SCREEN_RES" "$TMPBG"

# Use i3lock with the resized image
i3lock --image="$TMPBG"

