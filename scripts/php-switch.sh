#!/bin/bash

# PHP versions and their binary paths
declare -A php_versions=(
  ["8.2"]="/usr/bin/php82"
  ["8.4"]="/usr/bin/php84"
)

# Check binaries exist
valid_versions=()
for version in "${!php_versions[@]}"; do
  if [[ -x "${php_versions[$version]}" ]]; then
    valid_versions+=("$version")
  fi
done

if [ ${#valid_versions[@]} -eq 0 ]; then
  echo "No PHP versions found."
  exit 1
fi

echo "Select PHP version to switch to:"
select choice in "${valid_versions[@]}"; do
  if [[ -n "$choice" ]]; then
    target="${php_versions[$choice]}"
    break
  else
    echo "Invalid selection."
  fi
done

# Symlink /usr/bin/php to selected version
sudo ln -sf "$target" /usr/bin/php
echo "Switched PHP CLI to version $choice"
php -v

