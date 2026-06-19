#!/usr/bin/env bash
set -euo pipefail

# Remove trashed files older than 7 days from the FreeDesktop trash.
# Uses gio for listing (--dry-run) and direct rm for deletion (no undo).

readonly CUTOFF_DAYS=7
readonly TRASH_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/Trash"
readonly FILES_DIR="$TRASH_DIR/files"
readonly INFO_DIR="$TRASH_DIR/info"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

if $DRY_RUN; then
  echo -e "${YELLOW}[DRY RUN]${NC} No files will be deleted"
  echo ""
fi

CUTOFF_EPOCH=$(date -d "now - $CUTOFF_DAYS days" +%s)

deleted_count=0
skipped_count=0

for info_file in "$INFO_DIR"/*.trashinfo; do
  [ -f "$info_file" ] || continue

  deletion_date=$(grep '^DeletionDate=' "$info_file" | cut -d= -f2)
  deletion_epoch=$(date -d "$deletion_date" +%s 2>/dev/null) || continue

  basename=$(basename "$info_file" .trashinfo)

  if [ "$deletion_epoch" -le "$CUTOFF_EPOCH" ]; then
    if $DRY_RUN; then
      echo -e "  ${BLUE}[dry-run]${NC} Would delete: $basename (trashed $deletion_date)"
    else
      rm -rf "$FILES_DIR/$basename" 2>/dev/null || true
      rm -f "$info_file"
      echo -e "  ${RED}Deleted:${NC} $basename (trashed $deletion_date)"
    fi
    ((deleted_count++))
  else
    ((skipped_count++))
  fi
done

echo ""
if [ "$deleted_count" -eq 0 ]; then
  echo -e "${GREEN}Nothing to clean.${NC} ($skipped_count items are newer than $CUTOFF_DAYS days)"
else
  echo -e "${GREEN}Done.${NC} Removed $deleted_count item(s), skipped $skipped_count (newer than $CUTOFF_DAYS days)"
  if ! $DRY_RUN && command -v notify-send &>/dev/null; then
    notify-send -u low "Trash cleaned" "Removed $deleted_count item(s) older than $CUTOFF_DAYS days"
  fi
fi
