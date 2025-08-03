#!/usr/bin/env bash

set -e

# Get all installed PHP versions from /usr/bin/php*
available_versions=$(update-alternatives --list php | awk -F'/' '{print $NF}' | sort -Vr)

# Fallback if update-alternatives doesn't list anything
if [[ -z "$available_versions" ]]; then
  available_versions=$(compgen -c | grep -Po '^php\d\.\d$' | sort -Vr)
fi

versions=()
while IFS= read -r line; do
  versions+=("$line")
done <<< "$available_versions"

# Menu
echo "Available PHP versions:"
for i in "${!versions[@]}"; do
  echo "[$i] ${versions[$i]}"
done

read -rp "Select version to switch to [0-${#versions[@]}]: " index
selected=${versions[$index]}

echo "Switching to PHP version: $selected"

sudo update-alternatives --set php "/usr/bin/$selected"

version="${selected#php}" # e.g., 8.3
sudo update-alternatives --set phpize "/usr/bin/phpize$version"
sudo update-alternatives --set php-config "/usr/bin/php-config$version"

sudo pecl uninstall redis || true
printf '\n%.0s' {1..6} | sudo pecl install redis
