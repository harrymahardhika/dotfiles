#!/usr/bin/env bash

# Check if HDMI-2 is connected
if xrandr | grep "HDMI-2 connected"; then
  # HDMI-2 is connected, set it to the left of eDP-1
  xrandr --output HDMI-2 --mode 1920x1080 --pos 0x0 --output eDP-1 --auto --right-of HDMI-2
else
  # No external monitor connected, let xrandr auto-configure eDP-1
  xrandr --auto
fi

