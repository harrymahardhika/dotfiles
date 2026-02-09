#!/usr/bin/env bash
# Laptop power management script for Sway
# Monitors power state and adjusts system settings accordingly

set -euo pipefail

BATTERY_PATH="/sys/class/power_supply/BAT0"
AC_PATH="/sys/class/power_supply/AC"

# Check if on AC power
is_on_ac() {
    if [ -f "$AC_PATH/online" ]; then
        [ "$(cat "$AC_PATH/online")" = "1" ]
    else
        return 1
    fi
}

# Get current power state
if is_on_ac; then
    POWER_STATE="AC"
else
    POWER_STATE="BATTERY"
fi

# Apply power profile based on state
case "$POWER_STATE" in
    AC)
        # On AC power - performance mode
        # Restore normal brightness (adjust to your preference)
        if command -v brightnessctl >/dev/null 2>&1; then
            brightnessctl -q set 80% 2>/dev/null || true
        fi
        
        # Set CPU governor to performance (if available)
        if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
            echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1 || true
        fi
        ;;
        
    BATTERY)
        # On battery - power saving mode
        # Reduce brightness (adjust to your preference)
        if command -v brightnessctl >/dev/null 2>&1; then
            brightnessctl -q set 50% 2>/dev/null || true
        fi
        
        # Set CPU governor to powersave (if available)
        if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
            echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1 || true
        fi
        ;;
esac

exit 0
