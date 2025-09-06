#!/usr/bin/env bash

IMAGE=$(find -L "$HOME/wallpapers" -type f | shuf -n 1)

swaylock \
  -i "$IMAGE" \
  --color 1a1b26 \
  --indicator-idle-visible \
  --indicator-radius 120 \
  --indicator-thickness 10 \
  --ring-color 7aa2f7 \
  --inside-color 1a1b26 \
  --line-color 1a1b26 \
  --key-hl-color 9ece6a \
  --bs-hl-color f7768e \
  --text-color c0caf5
