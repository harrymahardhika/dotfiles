#!/usr/bin/env bash

# Directory containing your launcher scripts or .desktop files
LAUNCH_DIR="$HOME/scripts/webapps"

# List available files, pick one with rofi, and execute it
choice=$(ls -1 "$LAUNCH_DIR" | rofi -dmenu -i -p "Webapp:")

# Exit if nothing chosen
[ -z "$choice" ] && exit 0

# Run the chosen file
exec "$LAUNCH_DIR/$choice"

