#!/usr/bin/env bash
set -euo pipefail

# Script to clean up Neovim cache and data directories
# This removes temporary files, logs, swap files, and plugin caches

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Neovim directories
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

# Print header
echo -e "${BLUE}=== Neovim Cleanup Script ===${NC}\n"

# Function to get directory size
get_dir_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "N/A"
    fi
}

# Function to remove directory contents
cleanup_dir() {
    local dir="$1"
    local desc="$2"
    
    if [ -d "$dir" ]; then
        local size=$(get_dir_size "$dir")
        echo -e "${YELLOW}Cleaning:${NC} $desc"
        echo -e "  Path: $dir"
        echo -e "  Size: $size"
        
        rm -rf "$dir"/*
        
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}✓ Cleaned${NC}\n"
            return 0
        else
            echo -e "  ${RED}✗ Failed${NC}\n"
            return 1
        fi
    else
        echo -e "${YELLOW}Skipping:${NC} $desc (not found)\n"
        return 0
    fi
}

# Calculate total size before cleanup
echo -e "${BLUE}Calculating sizes...${NC}\n"
total_before=0

# Show what will be cleaned
echo -e "${BLUE}Directories to clean:${NC}"
echo "  • Cache:  $(get_dir_size "$NVIM_CACHE_DIR")"
echo "  • State:  $(get_dir_size "$NVIM_STATE_DIR")"
echo "  • Swap:   $(get_dir_size "$NVIM_STATE_DIR/swap")"
echo "  • Shada:  $(get_dir_size "$NVIM_STATE_DIR/shada")"
echo "  • Log:    $(get_dir_size "$NVIM_STATE_DIR/log")"
echo ""

# Ask for confirmation
read -p "Proceed with cleanup? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 0
fi

echo ""

# Clean cache directory (packer, lazy, etc.)
cleanup_dir "$NVIM_CACHE_DIR" "Cache directory"

# Clean state directory components
cleanup_dir "$NVIM_STATE_DIR/swap" "Swap files"
cleanup_dir "$NVIM_STATE_DIR/shada" "Shared data (history, marks, etc.)"
cleanup_dir "$NVIM_STATE_DIR/log" "Log files"

# Clean lazy.nvim plugin cache
cleanup_dir "$NVIM_DATA_DIR/lazy/cache" "Lazy.nvim cache"

# Clean Mason LSP server logs
cleanup_dir "$NVIM_DATA_DIR/mason/packages" "Mason package caches (optional - may need reinstall)"

# Summary
echo -e "${GREEN}=== Cleanup Complete ===${NC}"
echo ""
echo -e "${BLUE}Note:${NC} Plugin managers (lazy.nvim, mason) will re-download/compile on next Neovim start."
echo -e "${BLUE}Note:${NC} Your configuration files and plugins are preserved."
