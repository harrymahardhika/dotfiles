#!/bin/sh

BAT_PATH="/sys/class/power_supply/BAT0"
THRESHOLD_FILE="$BAT_PATH/charge_control_end_threshold"

if [ ! -f "$THRESHOLD_FILE" ]; then
  echo "Battery charge threshold not supported or BAT0 not found."
  exit 1
fi

case "$1" in
  limit)
    echo "Setting battery charge limit to 60%"
    echo 60 | sudo tee "$THRESHOLD_FILE" > /dev/null
    ;;
  full)
    echo "Setting battery charge limit to 95%"
    echo 95 | sudo tee "$THRESHOLD_FILE" > /dev/null
    ;;
  status)
    echo "🔋 Battery Status:"
    echo "----------------------------"
    echo "Charge Limit:          $(cat "$THRESHOLD_FILE")%"
    echo "Status:                $(cat "$BAT_PATH/status")"
    echo "Capacity (estimate):   $(cat "$BAT_PATH/capacity")%"

    if [ -f "$BAT_PATH/charge_now" ] && [ -f "$BAT_PATH/charge_full" ]; then
      echo "Charge (now/full):     $(cat "$BAT_PATH/charge_now") / $(cat "$BAT_PATH/charge_full") µAh"
    elif [ -f "$BAT_PATH/energy_now" ] && [ -f "$BAT_PATH/energy_full" ]; then
      echo "Charge (now/full):     $(cat "$BAT_PATH/energy_now") / $(cat "$BAT_PATH/energy_full") µWh"
    fi

    if [ -f "$BAT_PATH/energy_full_design" ]; then
      echo "Design Capacity:       $(cat "$BAT_PATH/energy_full_design") µWh"
    elif [ -f "$BAT_PATH/charge_full_design" ]; then
      echo "Design Capacity:       $(cat "$BAT_PATH/charge_full_design") µAh"
    fi

    if [ -f "$BAT_PATH/health" ]; then
      echo "Health:                $(cat "$BAT_PATH/health")"
    fi
    echo "----------------------------"
    ;;
  *)
    echo "Usage: $0 {limit|full|status}"
    exit 1
    ;;
esac
