#!/usr/bin/env bash
set -euo pipefail

# Where symlinks to Laravel projects live
SITES_DIR="$HOME/sites"

# Path to your nginx template inside dotfiles
TEMPLATE="$HOME/dotfiles/scripts/laravel-nginx/nginx.template"

# Where nginx expects site configs
CONF_DIR="/etc/nginx/sites-enabled"

# Dynamic PHP version and nginx user
php_version=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
nginx_user=$(whoami)

for site in "$SITES_DIR"/*; do
  # Only process symlinks
  [ -L "$site" ] || continue

  project=$(basename "$site")
  server_name="$project.test"

  # Ensure project has a public/index.php
  if [ ! -f "$site/public/index.php" ]; then
    echo "[WARN] Skipping $project — no public/index.php found"
    continue
  fi

  conf_file="$CONF_DIR/$project.conf"

  sed \
    -e "s|{{server_name}}|$server_name|g" \
    -e "s|{{project}}|$project|g" \
    -e "s|{{php_version}}|$php_version|g" \
    -e "s|{{root}}|$site|g" \
    "$TEMPLATE" | sudo tee "$conf_file" > /dev/null

  echo "[INFO] Generated config for $server_name → $conf_file"
done

# Reload nginx
sudo nginx -t && sudo systemctl reload nginx
echo "[DONE] All configs generated and nginx reloaded."
