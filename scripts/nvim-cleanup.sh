#!/usr/bin/env bash
set -euo pipefail

# Script to clean up Neovim cache and data directories
# Usage: ./nvim-cleanup.sh [--dry-run]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Neovim directories
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

# Stale VIMRUNTIME files from previous Neovim builds
STALE_VIMRUNTIME_FILES=(
  /usr/local/share/nvim/runtime/lua/vim/_editor.lua
  /usr/local/share/nvim/runtime/lua/vim/_defaults.lua
  /usr/local/share/nvim/runtime/lua/vim/_options.lua
  /usr/local/share/nvim/runtime/lua/vim/_system.lua
  /usr/local/share/nvim/runtime/lua/vim/shared.lua
)

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

get_dir_size() {
  if [ -d "$1" ]; then
    du -sh "$1" 2>/dev/null | cut -f1
  else
    echo "N/A"
  fi
}

do_rm() {
  if $DRY_RUN; then
    echo -e "  ${BLUE}[dry-run]${NC} rm -rf $*"
  else
    rm -rf "$@"
  fi
}

cleanup_dir() {
  local dir="$1"
  local desc="$2"
  local skip_hidden="${3:-false}"

  if [ -d "$dir" ]; then
    local size=$(get_dir_size "$dir")
    echo -e "${YELLOW}Cleaning:${NC} $desc"
    echo -e "  Path: $dir"
    echo -e "  Size: $size"

    if $DRY_RUN; then
      echo -e "  ${BLUE}[dry-run]${NC} Would delete contents"
    else
      shopt -s nullglob dotglob
      local entries=("$dir"/*)
      shopt -u nullglob dotglob
      if [ ${#entries[@]} -gt 0 ]; then
        do_rm "${dir:?}"/*
        if ! $DRY_RUN; then
          echo -e "  ${GREEN}✓ Cleaned${NC}"
        fi
      else
        echo -e "  ${YELLOW}(empty)${NC}"
      fi
    fi
    echo ""
    return 0
  else
    echo -e "${YELLOW}Skipping:${NC} $desc (not found)\n"
    return 0
  fi
}

echo -e "${BLUE}=== Neovim Cleanup Script ===${NC}"
$DRY_RUN && echo -e "${YELLOW}[DRY RUN MODE]${NC} - no files will be deleted\n" || echo ""

echo -e "${BLUE}Directories to clean:${NC}"
echo "  • Cache:  $(get_dir_size "$NVIM_CACHE_DIR")"
echo "  • State:  $(get_dir_size "$NVIM_STATE_DIR")"
echo "  • Swap:   $(get_dir_size "$NVIM_STATE_DIR/swap")"
echo "  • Shada:  $(get_dir_size "$NVIM_STATE_DIR/shada")"
echo "  • Log:    $(get_dir_size "$NVIM_STATE_DIR/log")"
echo "  • Lazy:   $(get_dir_size "$NVIM_DATA_DIR/lazy")"
echo "  • Mason registry: $(get_dir_size "$NVIM_DATA_DIR/mason/registry")"
echo "  • Mason log:      $(get_dir_size "$NVIM_DATA_DIR/mason/log")"
echo ""

# Check if stale VIMRUNTIME files exist
has_stale=false
for f in "${STALE_VIMRUNTIME_FILES[@]}"; do
  [ -f "$f" ] && has_stale=true && break
done
if $has_stale; then
  echo -e "${RED}⚠ Stale VIMRUNTIME files detected:${NC}"
  for f in "${STALE_VIMRUNTIME_FILES[@]}"; do
    [ -f "$f" ] && echo "    $f"
  done
  echo -e "${YELLOW}  These are leftovers from a previous Neovim build. Requires sudo.${NC}\n"
fi

if ! $DRY_RUN; then
  read -p "Proceed with cleanup? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
  fi
  echo ""
fi

# --- Cache ---
cleanup_dir "$NVIM_CACHE_DIR" "Cache directory"

# --- State ---
cleanup_dir "$NVIM_STATE_DIR/swap" "Swap files"
cleanup_dir "$NVIM_STATE_DIR/shada" "Shared data (history, marks, etc.)"
cleanup_dir "$NVIM_STATE_DIR/log" "Log files"

# --- Lazy plugins ---
cleanup_dir "$NVIM_DATA_DIR/lazy" "Lazy.nvim plugins"

# --- Mason (only registry + log, NOT packages to avoid full reinstall) ---
cleanup_dir "$NVIM_DATA_DIR/mason/registry" "Mason registry cache"
cleanup_dir "$NVIM_DATA_DIR/mason/log" "Mason log files"

# --- Stale VIMRUNTIME files (with sudo) ---
for f in "${STALE_VIMRUNTIME_FILES[@]}"; do
  if [ -f "$f" ]; then
    if $DRY_RUN; then
      echo -e "${BLUE}[dry-run]${NC} Would remove (via sudo): $f"
    else
      echo -e "${YELLOW}Removing:${NC} $f"
      sudo rm -f "$f"
      echo -e "  ${GREEN}✓ Removed${NC}"
    fi
  fi
done

echo -e "\n${GREEN}=== Cleanup Complete ===${NC}\n"
echo -e "${BLUE}Note:${NC} Plugin managers (lazy.nvim, mason) will re-download on next Neovim start."
echo -e "${BLUE}Note:${NC} Your configuration files and manually installed plugins are preserved."
