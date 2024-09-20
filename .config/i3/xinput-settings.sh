#!/bin/bash

MOUSE="pointer:Logitech Wireless Mouse"
xinput set-prop "$MOUSE" "libinput Natural Scrolling Enabled" 1
xinput set-prop "$MOUSE" "libinput Accel Speed" 0.5

TOUCHPAD="SynPS/2 Synaptics TouchPad"
xinput set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Natural Scrolling Enabled" 1
xinput set-prop "$TOUCHPAD" "libinput Accel Speed" 0.5

# Enable two-finger scrolling
# Note: "libinput Scroll Method Enabled" takes an array of values
# (0=two-finger, 1=edge, 2=on-button down)
xinput set-prop "$TOUCHPAD" "libinput Scroll Method Enabled" 0, 0, 1

