#!/usr/bin/env bash

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "unknown"
  fi
}

DISTRO=$(detect_distro)

case "$DISTRO" in
  ubuntu | pop)
    kitty --config ~/.config/kitty/kitty.conf -o font_size=11.5 -e tmux &
    ;;
  arch)
    kitty --config ~/.config/kitty/kitty.conf -o font_size=10.5 -e tmux &
    ;;
  *)
    kitty --config ~/.config/kitty/kitty.conf -o font_size=11 -e tmux &
    ;;
esac
