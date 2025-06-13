#!/bin/bash

SRC_DIR="$HOME/scripts/app"  # Replace with actual path
TARGET_DIR="/usr/local/bin"  # Change to /usr/bin if needed (with sudo)

for file in "$SRC_DIR"/*; do
    [ -e "$file" ] || continue   # skip if no matches

    basefile=$(basename "$file")
    target="$TARGET_DIR/$basefile"

    if [ -e "$target" ] || [ -L "$target" ]; then
        sudo rm -f "$target"
    fi

    sudo ln -s "$file" "$target"
    echo "Linked $file -> $target"
done
