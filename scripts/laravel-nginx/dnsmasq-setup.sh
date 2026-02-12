#!/usr/bin/env bash
set -euo pipefail

CONF_SRC="$HOME/dotfiles/scripts/laravel-nginx/dnsmasq.test.conf"
CONF_DST="/etc/dnsmasq.d/dev.conf"

# Ensure dnsmasq installed
if ! command -v dnsmasq >/dev/null 2>&1; then
    echo "[INFO] Installing dnsmasq..."
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed dnsmasq
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y dnsmasq
    else
        echo "[ERROR] Unsupported package manager. Install dnsmasq manually."
        exit 1
    fi
fi

# Ensure config directory exists
echo "[INFO] Ensuring /etc/dnsmasq.d exists..."
sudo mkdir -p /etc/dnsmasq.d

# Ensure dnsmasq loads /etc/dnsmasq.d/*.conf
if ! sudo grep -Eq '^[[:space:]]*conf-dir=/etc/dnsmasq\.d(,|\s|$)' /etc/dnsmasq.conf; then
    echo "[INFO] Enabling conf-dir=/etc/dnsmasq.d,*.conf in /etc/dnsmasq.conf"
    echo "conf-dir=/etc/dnsmasq.d,*.conf" | sudo tee -a /etc/dnsmasq.conf >/dev/null
fi

# Link our config
echo "[INFO] Linking dnsmasq config..."
sudo ln -sf "$CONF_SRC" "$CONF_DST"

# Restart dnsmasq
echo "[INFO] Restarting dnsmasq..."
sudo systemctl enable dnsmasq >/dev/null 2>&1 || true
sudo systemctl restart dnsmasq

# Show status
systemctl --no-pager --full status dnsmasq || true

echo "[DONE] dnsmasq is now serving *.test -> 127.0.0.1"
echo "[NOTE] Ensure your resolver uses 127.0.0.1 first (NetworkManager/systemd-resolved)."
