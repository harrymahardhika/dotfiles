#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Detect active monitors
if xrandr | grep -q "HDMI-2 connected"; then
  MONITOR=HDMI-2
  # MONITOR=eDP-1
elif xrandr | grep -q "HDMI-1 connected"; then
  # MONITOR=HDMI-1
  MONITOR=eDP-1
else
  MONITOR=eDP-1
fi

# Launch Polybar with the detected monitor
echo "---" | tee -a /tmp/polybar.log
MONITOR=$MONITOR polybar main --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown

