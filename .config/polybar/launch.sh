#!/usr/bin/env bash

polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar.log
polybar main --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
