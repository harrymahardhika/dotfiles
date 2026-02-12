#!/usr/bin/env bash
set -euo pipefail

# Where symlinks to Laravel projects live
SITES_DIR="$HOME/sites"

# Path to your nginx template inside dotfiles
TEMPLATE="$HOME/dotfiles/scripts/laravel-nginx/nginx.template"

# Where nginx expects site configs
if [ -d /etc/nginx/sites-enabled ]; then
  CONF_DIR="/etc/nginx/sites-enabled"
elif [ -d /etc/nginx/http.d ]; then
  CONF_DIR="/etc/nginx/http.d"
else
  CONF_DIR="/etc/nginx/conf.d"
fi

INCLUDE_GLOB="${CONF_DIR}/*.conf"
INCLUDE_LINE="    include ${INCLUDE_GLOB};"
HOSTS_FILE="/etc/hosts"
HOSTS_MANAGE="${HOSTS_MANAGE:-1}"
HOSTS_IP="${HOSTS_IP:-127.0.0.1}"
HOSTS_MARKER_BEGIN="# >>> laravel-nginx managed hosts >>>"
HOSTS_MARKER_END="# <<< laravel-nginx managed hosts <<<"

echo "[INFO] Using nginx config dir: $CONF_DIR"
sudo mkdir -p "$CONF_DIR"

# Ensure nginx loads generated site files
if ! sudo grep -qF "$INCLUDE_GLOB" /etc/nginx/nginx.conf; then
  echo "[INFO] Adding nginx include: $INCLUDE_LINE"
  tmp_file="$(mktemp)"
  awk -v line="$INCLUDE_LINE" '
    /^[[:space:]]*http[[:space:]]*{/ && !done {
      print
      print line
      done=1
      next
    }
    { print }
  ' /etc/nginx/nginx.conf > "$tmp_file"
  sudo cp "$tmp_file" /etc/nginx/nginx.conf
  rm -f "$tmp_file"
fi

# Selected PHP version (default: 8.4)
PHP_VERSION_FILE="$HOME/.config/laravel-nginx/php-version"
php_version="${PHP_VERSION:-8.4}"
if [ -f "$PHP_VERSION_FILE" ]; then
  php_version="$(tr -d '[:space:]' < "$PHP_VERSION_FILE")"
fi

if ! echo "$php_version" | grep -Eq '^[0-9]+\.[0-9]+$'; then
  echo "[ERROR] Invalid PHP version '$php_version'. Expected format like 8.4"
  exit 1
fi

php_slot="${php_version/./}"

# Pick first existing socket path, fallback to Arch-style php-fpm path
socket_candidates=(
  "/run/php${php_slot}-fpm/php-fpm.sock"
  "/run/php-fpm/php${php_slot}-fpm.sock"
  "/var/run/php/php${php_version}-fpm.sock"
  "/run/php/php${php_version}-fpm.sock"
)
php_fpm_socket=""
for sock in "${socket_candidates[@]}"; do
  if [ -S "$sock" ]; then
    php_fpm_socket="$sock"
    break
  fi
done
if [ -z "$php_fpm_socket" ]; then
  php_fpm_socket="/run/php${php_slot}-fpm/php-fpm.sock"
fi

echo "[INFO] Using PHP ${php_version} (socket: ${php_fpm_socket})"

generated_hosts=()

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
    -e "s|{{php_fpm_socket}}|$php_fpm_socket|g" \
    -e "s|{{root}}|$site|g" \
    "$TEMPLATE" | sudo tee "$conf_file" > /dev/null

  echo "[INFO] Generated config for $server_name → $conf_file"
  generated_hosts+=("$server_name")
done

if [ "$HOSTS_MANAGE" = "1" ]; then
  echo "[INFO] Updating $HOSTS_FILE managed block for generated .test domains"
  tmp_hosts="$(mktemp)"

  sudo awk \
    -v begin="$HOSTS_MARKER_BEGIN" \
    -v end="$HOSTS_MARKER_END" '
      $0 == begin { skip=1; next }
      $0 == end { skip=0; next }
      !skip { print }
    ' "$HOSTS_FILE" > "$tmp_hosts"

  {
    echo
    echo "$HOSTS_MARKER_BEGIN"
    if [ "${#generated_hosts[@]}" -eq 0 ]; then
      echo "# (no generated Laravel .test hosts)"
    else
      for host in "${generated_hosts[@]}"; do
        echo "${HOSTS_IP} ${host}"
      done
    fi
    echo "$HOSTS_MARKER_END"
  } >> "$tmp_hosts"

  sudo cp "$tmp_hosts" "$HOSTS_FILE"
  rm -f "$tmp_hosts"
fi

# Reload nginx
sudo nginx -t && sudo systemctl reload nginx
echo "[DONE] All configs generated and nginx reloaded."
