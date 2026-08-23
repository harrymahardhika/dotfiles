#!/usr/bin/env bash
# Generate themed payload files for every theme in themes/palettes/
# by hex-substituting the mocha masters using each theme's palette.
#
# NOTE: only top-level masters are regenerated. Per-config nvim payload files
# (themes/<theme>/nvim/<config>.lua) are hand-maintained — they're consumed by
# apply_nvim_payload() in scripts/theme-switch.sh.
set -euo pipefail

THEMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/themes"
PALETTES_DIR="$THEMES_DIR/palettes"
MOCHA_DIR="$THEMES_DIR/mocha"

usage() {
  echo "Usage: $(basename "$0") [theme...]"
  echo "Generates themes/<theme>/ payloads from themes/mocha/ + themes/palettes/<theme>.palette"
  echo "With no args, generates for all palettes except mocha."
  exit 1
}

[ -d "$MOCHA_DIR" ] || { echo "Missing themes/mocha/ masters" >&2; exit 1; }

# build sed expression: for each color, replace #<mochahex> -> #<themehex>.
# Multiple palette tokens can share a mocha hex (e.g. selection_bg/surface0 both
# use 313244); when they diverge in a target theme, later tokens must win, so
# keep a map keyed by source hex and emit one rule per hex.
build_sed() {
  local target_palette="$1"
  local name mocha_hex theme_hex
  local -A rule=()
  while IFS='=' read -r name mocha_hex; do
    [ -n "$name" ] || continue
    [[ "$name" == \#* ]] && continue
    mocha_hex="${mocha_hex%%[[:space:]]*}"
    [ -n "$mocha_hex" ] || continue
    theme_hex="$(grep -m1 "^${name}=" "$target_palette" | cut -d= -f2 | awk '{print $1}')"
    [ -n "$theme_hex" ] || { echo "Warning: $name missing from $(basename "$target_palette")" >&2; continue; }
    rule["#${mocha_hex}"]="#${theme_hex}"
  done < "$PALETTES_DIR/mocha.palette"
  sed_args=()
  for mocha_hex in "${!rule[@]}"; do
    sed_args+=("-e" "s|${mocha_hex}|${rule[$mocha_hex]}|g")
  done
}

themes=()
if [ "$#" -gt 0 ]; then
  themes=("$@")
else
  for p in "$PALETTES_DIR"/*.palette; do
    name="$(basename "$p" .palette)"
    [ "$name" = "mocha" ] && continue
    themes+=("$name")
  done
fi

for theme in "${themes[@]}"; do
  target_palette="$PALETTES_DIR/$theme.palette"
  [ -f "$target_palette" ] || { echo "No palette for $theme" >&2; continue; }
  target_dir="$THEMES_DIR/$theme"
  mkdir -p "$target_dir"

  build_sed "$target_palette"

  for master in "$MOCHA_DIR"/*; do
    [ -f "$master" ] || continue
    base="$(basename "$master")"
    case "$base" in
      # ghostty uses bare hex (no '#') for background/foreground/cursor;
      # derive those from the palette (base/text/cursor_color/surface1)
      ghostty)
        base_hex="$(grep -m1 '^base=' "$target_palette" | cut -d= -f2 | awk '{print $1}')"
        text_hex="$(grep -m1 '^text=' "$target_palette" | cut -d= -f2 | awk '{print $1}')"
        cursor_hex="$(grep -m1 '^cursor_color=' "$target_palette" | cut -d= -f2 | awk '{print $1}')"
        sel_hex="$(grep -m1 '^surface1=' "$target_palette" | cut -d= -f2 | awk '{print $1}')"
        # replace #hex first, then bare hex for the non-palette keys
        sed "${sed_args[@]}" \
          -e "s/^background = 1e1e2e/background = ${base_hex}/" \
          -e "s/^foreground = cdd6f4/foreground = ${text_hex}/" \
          -e "s/^cursor-color = f5e0dc/cursor-color = ${cursor_hex}/" \
          -e "s/^cursor-text = 1e1e2e/cursor-text = ${base_hex}/" \
          -e "s/^selection-background = 45475a/selection-background = ${sel_hex}/" \
          -e "s/^selection-foreground = cdd6f4/selection-foreground = ${text_hex}/" \
          "$master" > "$target_dir/$base"
        ;;
      bat.tmTheme)
        # rewrite the internal <name> to the theme slug for --theme= matching
        sed "${sed_args[@]}" \
          -e '0,/<string>Catppuccin Mocha<\/string>/s//<string>'"$theme"'<\/string>/' \
          "$master" > "$target_dir/$base"
        ;;
      zen.css|rofi.rasi)
        # The accent slot is a *semantic* accent (border_accent), not the base
        # blue it shares a mocha source hex with. Last-wins above maps it to the
        # base color, so restore the semantic border_accent afterwards. This is
        # what keeps kanagawa's boatYellow1 accent (#938056) intact.
        sed "${sed_args[@]}" "$master" > "$target_dir/$base"
        accent_hex="$(grep -m1 '^border_accent=' "$target_palette" | cut -d= -f2 | awk '{print $1}')"
        if [ "$base" = "zen.css" ]; then
          sed -i -E "s/^([[:space:]]*--zen-accent: )#[0-9a-fA-F]+/\1#${accent_hex}/" "$target_dir/$base"
          sed -i -E "s/^([[:space:]]*--zen-accent: #[0-9a-fA-F]+;)  \/\* .* \*\//\1  \/* accent *\//" "$target_dir/$base"
        else
          sed -i -E "s/^([[:space:]]*accent: )#[0-9a-fA-F]+/\1#${accent_hex}/" "$target_dir/$base"
          sed -i -E "s/^([[:space:]]*accent: #[0-9a-fA-F]+;)  \/\* .* \*\//\1  \/* accent *\//" "$target_dir/$base"
        fi
        ;;
      *)
        sed "${sed_args[@]}" "$master" > "$target_dir/$base"
        ;;
    esac
  done

  echo "Generated $theme payloads in $target_dir"
done
