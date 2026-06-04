#!/usr/bin/env bash

set -euo pipefail

ANTIDOTE_HOME="${ANTIDOTE_HOME:-$HOME/.antidote}"
ANTIDOTE_REPO="https://github.com/mattmc3/antidote.git"
ANTIDOTE_PLUGINS_FILE="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

if [[ -d "$ANTIDOTE_HOME/.git" ]]; then
  echo "Updating Antidote in $ANTIDOTE_HOME..."
  git -C "$ANTIDOTE_HOME" pull --ff-only
elif [[ -L "$ANTIDOTE_HOME" ]]; then
  echo "Removing stale symlink at $ANTIDOTE_HOME..."
  rm "$ANTIDOTE_HOME"
  echo "Installing Antidote into $ANTIDOTE_HOME..."
  git clone --depth=1 "$ANTIDOTE_REPO" "$ANTIDOTE_HOME"
elif [[ -e "$ANTIDOTE_HOME" && ! -d "$ANTIDOTE_HOME/.git" ]]; then
  echo "Error: $ANTIDOTE_HOME exists but is not a git checkout."
  echo "Remove or rename it, then rerun this script."
  exit 1
else
  echo "Installing Antidote into $ANTIDOTE_HOME..."
  git clone --depth=1 "$ANTIDOTE_REPO" "$ANTIDOTE_HOME"
fi

if [[ ! -r "$ANTIDOTE_HOME/antidote.zsh" ]]; then
  echo "Error: missing $ANTIDOTE_HOME/antidote.zsh after install/update."
  exit 1
fi

echo "Updating Antidote bundles..."
zsh -lc "source \"$ANTIDOTE_HOME/antidote.zsh\" && antidote update < \"$ANTIDOTE_PLUGINS_FILE\""

echo "Antidote bootstrap/update complete."
