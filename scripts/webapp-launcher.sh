#!/usr/bin/env bash

# Directory containing your launcher scripts or .desktop files
LAUNCH_DIR="$HOME/scripts/webapps"

# List available files, pick one with rofi, and execute it
choice=$(find "$LAUNCH_DIR" -maxdepth 1 -type f -printf '%f\n' | sort | rofi -dmenu -i -p "Webapp:")

# Exit if nothing chosen
[ -z "$choice" ] && exit 0

# Run the chosen file with bash explicitly
bash "$LAUNCH_DIR/$choice"

