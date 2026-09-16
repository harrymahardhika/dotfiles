#!/usr/bin/env bash
# swaylock launcher for Hyprland — alternative to hyprlock.
#
# hyprlock has a recurring, unresolved bug where its session-lock handshake
# with Hyprland ("onLockFinished called. Seems we got yeeten.") gets stuck
# around suspend/resume, wedging the display and forcing a reboot. swaylock
# uses the same standard ext-session-lock-v1 protocol but is a separate,
# more battle-tested codebase — used here instead for lock_cmd/
# before_sleep_cmd in hypridle.conf. See memory: hypr-suspend-resume-crash.
#
# Colors are catppuccin-mocha, inlined the same way as hyprlock.conf.
# Run `theme-switch sync-masters` after editing so masters stay authoritative,
# then wire this file into theme-switch.sh's inline-apply + sync_masters
# lists (see apply_hyprlock/apply_hyprlock_inline for the pattern).

# ----- Catppuccin Mocha Palette -----
color_base="1e1e2e"
color_text="cdd6f4"
color_accent="89b4fa"   # Blue
color_check="a6e3a1"    # Green
color_fail="f38ba8"     # Red

THEME_STATE="$HOME/.cache/theme-current"
THEME="mocha"
[ -f "$THEME_STATE" ] && THEME="$(cat "$THEME_STATE")"

WALLPAPER_DIR="$HOME/wallpapers/$THEME"
[ -d "$WALLPAPER_DIR" ] || WALLPAPER_DIR="$HOME/wallpapers"

IMAGE="$(find -L "$WALLPAPER_DIR" -maxdepth 1 -type f 2>/dev/null | shuf -n 1)"

args=(
  --indicator-idle-visible
  --indicator-radius 120
  --indicator-thickness 10
  --ring-color "$color_base"
  --ring-ver-color "$color_accent"
  --ring-wrong-color "$color_fail"
  --ring-clear-color "$color_check"
  --inside-color "$color_base"
  --line-color "$color_base"
  --key-hl-color "$color_check"
  --bs-hl-color "$color_fail"
  --text-color "$color_text"
  --separator-color "$color_base"
  --font "JetBrainsMono Nerd Font"
)

if [ -n "$IMAGE" ]; then
  args+=(-i "$IMAGE")
else
  args+=(--color "$color_base")
fi

exec swaylock "${args[@]}"
