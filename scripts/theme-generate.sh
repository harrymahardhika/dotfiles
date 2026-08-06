#!/usr/bin/env bash
# Generate themed payload files for every theme in themes/palettes/
# by hex-substituting the mocha masters using each theme's palette.
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

# build sed expression: for each color, replace #<mochahex> -> #<themehex>
build_sed() {
  local target_palette="$1"
  local mocha_hex theme_hex
  sed_args=()
  while IFS== read -r name mocha_hex; do
    [ -n "$name" ] || continue
    [[ "$name" == \#* ]] && continue
    theme_hex="$(grep -m1 "^${name}=" "$target_palette" | cut -d= -f2)"
    [ -n "$theme_hex" ] || { echo "Warning: $name missing from $(basename "$target_palette")" >&2; continue; }
    sed_args+=("-e" "s/#${mocha_hex}/#${theme_hex}/g")
  done < "$PALETTES_DIR/mocha.palette"
}

# map mocha hex -> theme hex for ANSI RGB triplets (statusline)
build_rgb_sed() {
  local target_palette="$1"
  local name mocha_hex theme_hex
  sed_rgb_args=()
  while IFS== read -r name mocha_hex; do
    [ -n "$name" ] || continue
    [[ "$name" == \#* ]] && continue
    theme_hex="$(grep -m1 "^${name}=" "$target_palette" | cut -d= -f2)"
    [ -n "$theme_hex" ] || continue
    mocha_rgb="$(printf '%d;%d;%d' 0x${mocha_hex:0:2} 0x${mocha_hex:2:2} 0x${mocha_hex:4:2})"
    theme_rgb="$(printf '%d;%d;%d' 0x${theme_hex:0:2} 0x${theme_hex:2:2} 0x${theme_hex:4:2})"
    sed_rgb_args+=("-e" "s/${mocha_rgb}/${theme_rgb}/g")
  done < "$PALETTES_DIR/mocha.palette"
}

# map mocha hex -> theme hex for hyprlock's rgb(r,g,b) / rgba(r,g,b,a) syntax
build_hyprlock_sed() {
  local target_palette="$1"
  local name mocha_hex theme_hex
  sed_hl_args=()
  while IFS== read -r name mocha_hex; do
    [ -n "$name" ] || continue
    [[ "$name" == \#* ]] && continue
    theme_hex="$(grep -m1 "^${name}=" "$target_palette" | cut -d= -f2)"
    [ -n "$theme_hex" ] || continue
    mocha_rgb="$(printf 'rgb(%d,%d,%d)' 0x${mocha_hex:0:2} 0x${mocha_hex:2:2} 0x${mocha_hex:4:2})"
    theme_rgb="$(printf 'rgb(%d,%d,%d)' 0x${theme_hex:0:2} 0x${theme_hex:2:2} 0x${theme_hex:4:2})"
    sed_hl_args+=("-e" "s/${mocha_rgb}/${theme_rgb}/g")
    mocha_rgba="$(printf 'rgba(%d,%d,%d' 0x${mocha_hex:0:2} 0x${mocha_hex:2:2} 0x${mocha_hex:4:2})"
    theme_rgba="$(printf 'rgba(%d,%d,%d' 0x${theme_hex:0:2} 0x${theme_hex:2:2} 0x${theme_hex:4:2})"
    sed_hl_args+=("-e" "s/${mocha_rgba}/${theme_rgba}/g")
  done < "$PALETTES_DIR/mocha.palette"
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
      *)
        sed "${sed_args[@]}" "$master" > "$target_dir/$base"
        ;;
    esac
  done

  echo "Generated $theme payloads in $target_dir"
done
