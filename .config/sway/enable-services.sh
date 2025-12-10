#!/usr/bin/env bash
# Script to enable sway systemd services

set -euo pipefail

echo "Step 1: Restowing dotfiles to create systemd service symlinks..."
cd ~/dotfiles
stow --restow .

echo ""
echo "Step 2: Reloading systemd daemon..."
systemctl --user daemon-reload

echo ""
echo "Step 3: Enabling sway systemd user services..."

# Enable services
systemctl --user enable waybar.service
systemctl --user enable swayidle.service
systemctl --user enable swww-daemon.service
systemctl --user enable cliphist.service
systemctl --user enable dunst.service
systemctl --user enable udiskie.service

# Enable battery warning timer
systemctl --user enable battery-warning.timer

echo ""
echo "Services enabled. They will start on next login."
echo "To start them now, run:"
echo "  systemctl --user start waybar swayidle swww-daemon cliphist dunst udiskie battery-warning.timer"
echo ""
echo "To check status:"
echo "  systemctl --user status waybar swayidle swww-daemon cliphist dunst udiskie"
echo "  systemctl --user list-timers"
