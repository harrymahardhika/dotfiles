#!/usr/bin/env bash
set -euo pipefail

CONF_SRC="$HOME/dotfiles/scripts/laravel-nginx/dnsmasq.test.conf"
CONF_DST="/etc/dnsmasq.d/dev.conf"

# Ensure dnsmasq installed
if ! command -v dnsmasq >/dev/null 2>&1; then
    echo "[INFO] Installing dnsmasq..."
    sudo apt-get update
    sudo apt-get install -y dnsmasq
fi

# Ensure config directory exists
echo "[INFO] Ensuring /etc/dnsmasq.d exists..."
sudo mkdir -p /etc/dnsmasq.d

# Link our config
echo "[INFO] Linking dnsmasq config..."
sudo ln -sf "$CONF_SRC" "$CONF_DST"

# Restart dnsmasq
echo "[INFO] Restarting dnsmasq..."
sudo systemctl restart dnsmasq

# Show status
systemctl --no-pager --full status dnsmasq || true

echo "[DONE] dnsmasq is now serving *.test → 127.0.0.1"
