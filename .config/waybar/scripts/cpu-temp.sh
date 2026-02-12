#!/usr/bin/env bash

for h in /sys/class/hwmon/hwmon*; do
  if [ "$(cat "$h/name" 2>/dev/null)" = "coretemp" ] && [ -r "$h/temp1_input" ]; then
    awk '{printf " %d°C", $1/1000}' "$h/temp1_input"
    exit 0
  fi
done

echo " N/A"
