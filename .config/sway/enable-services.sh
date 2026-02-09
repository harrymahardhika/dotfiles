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

# Enable services (swww-daemon is started by sway config, not enabled here)
systemctl --user enable waybar.service
systemctl --user enable swayidle.service
systemctl --user enable cliphist.service
systemctl --user enable dunst.service
systemctl --user enable udiskie.service
systemctl --user enable fix-usb.service

# Enable battery warning timer
systemctl --user enable battery-warning.timer

echo ""
echo "Services enabled. They will start on next login."
echo "Note: swww-daemon is started by sway config after environment setup"
echo ""
echo "To start them now, run:"
echo "  systemctl --user start waybar swayidle cliphist dunst udiskie fix-usb battery-warning.timer"
echo ""
echo "To check status:"
echo "  systemctl --user status waybar swayidle cliphist dunst udiskie fix-usb"
echo "  systemctl --user list-timers"
