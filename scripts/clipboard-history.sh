#!/usr/bin/env bash

# Remember what was focused before rofi steals it, so we know which paste
# combo to send afterward (terminals use Ctrl+Shift+V, everything else Ctrl+V)
active_class=$(hyprctl activewindow -j | jq -r '.class // empty')

# Choose from history with rofi
chosen=$(cliphist list | rofi -dmenu -i -p "Clipboard" -theme-str 'window {width: 50%; height: 600px;}' -theme-str 'listview {columns: 1; lines: 15;}')

# If something was chosen, copy it back and paste into the previously focused window
if [ -n "$chosen" ]; then
	cliphist decode <<< "$chosen" | wl-copy
	sleep 0.1
	# Terminal classes use Ctrl+Shift+V. com.mitchellh.ghostty is confirmed
	# (verified via `hyprctl activewindow -j`, the user's daily driver);
	# the rest are untested best guesses, included for completeness.
	case "$active_class" in
	com.mitchellh.ghostty | org.wezfurlong.wezterm | kitty | Alacritty | foot | footclient)
		wtype -M ctrl -M shift -k v -m shift -m ctrl
		;;
	*)
		wtype -M ctrl -k v -m ctrl
		;;
	esac
fi

