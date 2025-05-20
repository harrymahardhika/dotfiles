#!/bin/bash

CONFIG_DIR="$HOME/nvim-configs"

# Get all available configurations
configs=($(ls -1 "$CONFIG_DIR"))

if [ ${#configs[@]} -eq 0 ]; then
  echo "No configurations found in $CONFIG_DIR"
  exit 1
fi

echo "Select a Neovim configuration:"
select TARGET_CONFIG in "${configs[@]}"; do
  if [ -n "$TARGET_CONFIG" ]; then
    break
  else
    echo "Invalid selection."
  fi
done

# Remove the current symlink or nvim directory
if [ -L "$HOME/.config/nvim" ] || [ -d "$HOME/.config/nvim" ]; then
  rm -rf "$HOME/.config/nvim"
fi

# Create the symlink to the selected configuration
ln -s "$CONFIG_DIR/$TARGET_CONFIG" "$HOME/.config/nvim"
echo "Switched to Neovim configuration: $TARGET_CONFIG"
