#!/bin/bash

LOW_BATTERY=15
CRITICAL_BATTERY=5
BAT_PATH="/sys/class/power_supply/BAT0"

# Ensure battery info is available
if [[ ! -f "$BAT_PATH/capacity" || ! -f "$BAT_PATH/status" ]]; then
    exit 1
fi

BATTERY_LEVEL=$(<"$BAT_PATH/capacity")
BATTERY_STATUS=$(<"$BAT_PATH/status")

# Avoid duplicate notifications
STATE_FILE="/tmp/.battery_warn_state"

if [[ "$BATTERY_STATUS" != "Charging" ]]; then
    if (( BATTERY_LEVEL <= CRITICAL_BATTERY )); then
        LAST_STATE=$(<"$STATE_FILE" 2>/dev/null)
        if [[ "$LAST_STATE" != "critical" ]]; then
            notify-send -u critical "⚠ Critical Battery" "Battery is at ${BATTERY_LEVEL}%. Plug in your charger!"
            echo "critical" > "$STATE_FILE"
        fi
    elif (( BATTERY_LEVEL <= LOW_BATTERY )); then
        LAST_STATE=$(<"$STATE_FILE" 2>/dev/null)
        if [[ "$LAST_STATE" != "low" ]]; then
            notify-send -u normal "⚠ Low Battery" "Battery is at ${BATTERY_LEVEL}%. Consider plugging in."
            echo "low" > "$STATE_FILE"
        fi
    else
        rm -f "$STATE_FILE"
    fi
else
    rm -f "$STATE_FILE"
fi
