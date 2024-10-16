#!/bin/bash

CONFIG_DIR="$HOME/nvim-configs"
TARGET_CONFIG="$1"  # The argument passed to the script is the desired config

if [ -z "$TARGET_CONFIG" ]; then
  echo "Usage: $0 <config-name>"
  echo "Available configurations:"
  ls "$CONFIG_DIR"
  exit 1
fi

# Check if the requested configuration exists
if [ ! -d "$CONFIG_DIR/$TARGET_CONFIG" ]; then
  echo "Configuration '$TARGET_CONFIG' not found!"
  exit 1
fi

# Remove the current symlink or nvim directory
if [ -L "$HOME/.config/nvim" ] || [ -d "$HOME/.config/nvim" ]; then
  rm -rf "$HOME/.config/nvim"
fi

# Create the symlink to the selected configuration
ln -s "$CONFIG_DIR/$TARGET_CONFIG" "$HOME/.config/nvim"
echo "Switched to Neovim configuration: $TARGET_CONFIG"

