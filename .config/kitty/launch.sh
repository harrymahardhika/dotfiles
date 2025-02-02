#!/usr/bin/env bash

# Function to detect the Linux distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "unknown"
  fi
}

# Detect the Linux distribution
DISTRO=$(detect_distro)

# Set default font size based on distro
case "$DISTRO" in
  ubuntu | pop)
    FONT_SIZE="11.5"
    ;;
  arch)
    FONT_SIZE="10.5"
    ;;
  *)
    FONT_SIZE="11"
    ;;
esac

# Check if --tmux argument is passed
if [[ "$1" == "--tmux" ]]; then
  # Launch Kitty with tmux
  kitty --config ~/.config/kitty/kitty.conf -o font_size=$FONT_SIZE tmux attach || tmux new-session &
else
  # Launch Kitty normally
  kitty --config ~/.config/kitty/kitty.conf -o font_size=$FONT_SIZE &
fi

