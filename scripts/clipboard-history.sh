#!/usr/bin/env bash

# Choose from history with rofi
chosen=$(cliphist list | rofi -dmenu -i -p "Clipboard" -theme-str 'window {width: 50%;}' -theme-str 'listview {columns: 1; lines: 10;}')

# If something was chosen, copy it back
[ -n "$chosen" ] && cliphist decode <<< "$chosen" | wl-copy

