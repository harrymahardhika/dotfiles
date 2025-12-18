#!/usr/bin/env bash
# Fix USB ports by disabling autosuspend

for usb in /sys/bus/usb/devices/*/power/control; do
  if [ -w "$usb" ]; then
    echo on > "$usb" 2>/dev/null
  fi
done
