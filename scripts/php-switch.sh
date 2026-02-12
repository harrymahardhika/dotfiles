#!/bin/bash

set -euo pipefail

# Supported versions on this setup
versions=("8.4" "8.3")
version=""

pick_version() {
  if [ "${1:-}" = "8.4" ] || [ "${1:-}" = "8.3" ]; then
    version="$1"
    return 0
  fi

  echo "Select PHP version to switch to:" >&2
  select choice in "${versions[@]}"; do
    if [[ -n "${choice:-}" ]]; then
      version="$choice"
      return 0
    fi
    echo "Invalid selection." >&2
  done
}

pick_version "${1:-}"
slot="${version/./}"

php_bin="/usr/bin/php${slot}"
pecl_bin="/usr/bin/pecl${slot}"
phpize_bin="/usr/bin/phpize${slot}"
php_config_bin="/usr/bin/php-config${slot}"

for bin in "$php_bin" "$pecl_bin" "$phpize_bin" "$php_config_bin"; do
  if [ ! -x "$bin" ]; then
    echo "Missing binary: $bin"
    exit 1
  fi
done

# Use user-level shims so no system overwrite is required.
mkdir -p "$HOME/.local/bin"
ln -sf "$php_bin" "$HOME/.local/bin/php"
ln -sf "$pecl_bin" "$HOME/.local/bin/pecl"
ln -sf "$phpize_bin" "$HOME/.local/bin/phpize"
ln -sf "$php_config_bin" "$HOME/.local/bin/php-config"

echo "Switched user PHP tools to version $version"
echo "php -> $(readlink -f "$HOME/.local/bin/php")"
echo "pecl -> $(readlink -f "$HOME/.local/bin/pecl")"

hash -r 2>/dev/null || true
php -v | head -n 1
