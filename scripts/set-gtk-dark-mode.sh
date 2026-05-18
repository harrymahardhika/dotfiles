#!/usr/bin/env bash
set -euo pipefail

# Prefer dark for desktop-aware GTK4/libadwaita apps.
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
fi
