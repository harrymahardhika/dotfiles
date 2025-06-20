#!/bin/bash
#
# Get Mouse and Touchpad IDs dynamically
# MOUSE_ID=$(xinput list | grep -i "Logitech Wireless Mouse" | awk '{print $6}' | sed 's/id=//')
TOUCHPAD_ID=$(xinput list | grep -i "SynPS/2 Synaptics TouchPad" | awk '{print $6}' | sed 's/id=//')

# Check if IDs are found before applying settings
# if [ -n "$MOUSE_ID" ]; then
#     xinput set-prop "$MOUSE_ID" "libinput Natural Scrolling Enabled" 1
#     xinput set-prop "$MOUSE_ID" "libinput Scroll Method Enabled" 0 0 1
#     xinput set-prop "$MOUSE_ID" "libinput Accel Speed" 0.5
# fi

if [ -n "$TOUCHPAD_ID" ]; then
    xinput set-prop "$TOUCHPAD_ID" "libinput Tapping Enabled" 1
    xinput set-prop "$TOUCHPAD_ID" "libinput Natural Scrolling Enabled" 1
    xinput set-prop "$TOUCHPAD_ID" "libinput Accel Speed" 0.5
    xinput set-prop "$TOUCHPAD_ID" "libinput Scroll Method Enabled" 0 0 1
fi
