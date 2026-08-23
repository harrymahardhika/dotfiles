#!/usr/bin/env bash
set -euo pipefail

# Switch the active Neovim configuration (~/.config/nvim symlink).
#
# Usage:
#   nvim-switch.sh           interactive picker
#   nvim-switch.sh <name>    switch directly (e.g. nvim-switch twenty-six)

CONFIG_DIR="$HOME/nvim-configs"
[ -d "$CONFIG_DIR" ] || CONFIG_DIR="$HOME/dotfiles/nvim-configs"

NVIM_LINK="$HOME/.config/nvim"

configs=()
for dir in "$CONFIG_DIR"/*; do
  if [ -d "$dir" ]; then
    configs+=("$(basename "$dir")")
  fi
done

if [ ${#configs[@]} -eq 0 ]; then
  echo "No configurations found in $CONFIG_DIR" >&2
  exit 1
fi

TARGET_CONFIG="${1:-}"
if [ -n "$TARGET_CONFIG" ]; then
  if [ ! -d "$CONFIG_DIR/$TARGET_CONFIG" ]; then
    echo "Unknown config '$TARGET_CONFIG'. Available:" >&2
    printf '  %s\n' "${configs[@]}" >&2
    exit 1
  fi
else
  echo "Select a Neovim configuration:"
  select TARGET_CONFIG in "${configs[@]}"; do
    if [ -n "$TARGET_CONFIG" ]; then
      break
    fi
    if [ -z "$REPLY" ]; then
      echo "Aborted." >&2
      exit 1
    fi
    echo "Invalid selection."
  done
fi

if [ -z "$TARGET_CONFIG" ]; then
  echo "No config selected." >&2
  exit 1
fi

# Idempotent: switching to the active config is a no-op.
if [ -L "$NVIM_LINK" ]; then
  current="$(basename "$(readlink -f "$NVIM_LINK")")"
  if [ "$current" = "$TARGET_CONFIG" ]; then
    echo "Already using Neovim configuration: $TARGET_CONFIG"
    exit 0
  fi
  rm "$NVIM_LINK"
elif [ -e "$NVIM_LINK" ]; then
  # Real directory (not stow-managed): never delete user data.
  echo "Refusing: $NVIM_LINK exists and is not a symlink." >&2
  echo "Move it aside (e.g. mv ~/.config/nvim ~/.config/nvim.bak), then re-run." >&2
  exit 1
fi

ln -s "$CONFIG_DIR/$TARGET_CONFIG" "$NVIM_LINK"
echo "Switched to Neovim configuration: $TARGET_CONFIG"
