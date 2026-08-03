#!/usr/bin/env bash
# theme-switch.sh — apply a color theme across the whole dotfiles setup.
#
# Themes live in ~/dotfiles/themes/<name>/ (payload files) driven by
# themes/palettes/<name>.palette (semantic color map). Run scripts/theme-generate.sh
# to (re)build payload files from the palettes.
#
# Usage:
#   theme-switch list                 # list available themes
#   theme-switch current              # print active theme
#   theme-switch apply <name>         # apply a theme everywhere + reload
#   theme-switch apply <name> --dry   # preview what would change
#   theme-switch pick                 # rofi frontend (see theme-pick.sh)
#   theme-switch sync-masters         # re-sync mocha masters for inline files
#
# Inline (non-payload) configs are rendered from mocha masters under
# themes/mocha/inline/ (see sync-masters), so switching back and forth is
# lossless. Payload files come from themes/<name>/.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
THEMES_DIR="$DOTFILES/themes"
PALETTES_DIR="$THEMES_DIR/palettes"
STATE_FILE="${THEME_STATE:-$HOME/.cache/theme-current}"

DEFAULT_THEME="mocha"
ACTIVE_CFG="$HOME/.config/nvim"
ZEN_PROFILE="oct5ov6c.Default (release)"

usage() {
  sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

die() { echo "theme-switch: $*" >&2; exit 1; }

current_theme() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "$DEFAULT_THEME"
  fi
}

list_themes() {
  for p in "$PALETTES_DIR"/*.palette; do
    basename "$p" .palette
  done | sort
}

# ---- helpers --------------------------------------------------------------

has_cmd() { command -v "$1" >/dev/null 2>&1; }

# notify through mako/notify-send, honoring --dry
notify() {
  [ "${DRY:-0}" = "1" ] && return 0
  has_cmd notify-send || return 0
  notify-send -a "theme-switch" -u "$1" -t "${2:-8000}" "$3" "$4" >/dev/null 2>&1 || true
}

notify_start() {
  notify normal 6000 "Switching theme" "Starting $1..."
}

notify_processing() {
  notify normal 6000 "Switching theme" "Applying $1…"
}

notify_done() {
  notify normal 5000 "Theme changed" "Switched to $1"
}

# run a command, honoring --dry
run() {
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: $*"
  else
    "$@"
  fi
}

# write file content honoring --dry
write_file() {
  local content="$1" path="$2"
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: write -> $path"
    return
  fi
  mkdir -p "$(dirname "$path")"
  printf '%s' "$content" > "$path"
}

# rewrite a single line in a file (pointer swap)
rewrite_line() {
  local file="$(resolve_file "$1")" pattern="$2" replacement="$3"
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: sed -i 's|$pattern|$replacement|' $file"
    return
  fi
  [ -f "$file" ] || return 0
  sed -i "s|$pattern|$replacement|" "$file"
}

# copy a payload file into place
install_payload() {
  local theme="$1" payload="$2" dest="$3"
  run cp "$THEMES_DIR/$theme/$payload" "$dest"
}

# ---- app actions ----------------------------------------------------------

apply_kitty() {
  local theme="$1"
  local dest="$HOME/.config/kitty"
  install_payload "$theme" "kitty.conf" "$dest/$theme.conf"
  rewrite_line "$dest/kitty.conf" "include [a-zA-Z0-9_.-]*.conf" "include $theme.conf"
}

apply_ghostty() {
  local theme="$1"
  local dest="$HOME/.config/ghostty"
  install_payload "$theme" "ghostty" "$dest/themes/$theme"
  rewrite_line "$dest/config" '^theme = .*' "theme = $theme"
}

apply_alacritty() {
  local theme="$1"
  local dest="$HOME/.config/alacritty"
  install_payload "$theme" "alacritty.toml" "$dest/$theme.toml"
  rewrite_line "$dest/alacritty.toml" 'import = \["~/.config/alacritty/.*\.toml"\]' "import = [\"~/.config/alacritty/$theme.toml\"]"
}

apply_wezterm() {
  local theme="$1"
  case "$theme" in
    mocha)    local name="Catppuccin Mocha" ;;
    kanagawa) local name="Kanagawa Wave" ;;
    *)        local name="$theme" ;;
  esac
  rewrite_line "$HOME/.config/wezterm/wezterm.lua" 'color_scheme = ".*"' "color_scheme = \"$name\""
}

apply_helix() {
  local theme="$1"
  case "$theme" in
    kanagawa) local name="kanagawa" ;;
    mocha)    local name="catppuccin_mocha" ;;
    *)        local name="$theme" ;;
  esac
  rewrite_line "$HOME/.config/helix/config.toml" 'theme = ".*"' "theme = \"$name\""
}

apply_zellij() {
  local theme="$1"
  rewrite_line "$HOME/.config/zellij/config.kdl" 'theme ".*"' "theme \"$theme\""
}

apply_rofi() {
  local theme="$1"
  local dest="$HOME/.config/rofi"
  install_payload "$theme" "rofi.rasi" "$dest/$theme.rasi"
  rewrite_line "$dest/config.rasi" '@theme ".*"' "@theme \"$theme\""
}

apply_waybar() {
  local theme="$1"
  local dest="$HOME/.config/waybar"
  install_payload "$theme" "waybar.css" "$dest/$theme.css"
  for style in style.css sway-style.css sway-style-solid.css sway-style-transparent.css; do
    rewrite_line "$dest/$style" '@import "[^"]*";' "@import \"$theme.css\";"
  done
  # calendar span colors are hardcoded hex in config.jsonc
  apply_palette_inline "$dest/config.jsonc" "$theme"
  apply_palette_inline "$dest/sway-config.jsonc" "$theme"
}

apply_btop() {
  local theme="$1"
  local dest="$HOME/.config/btop"
  install_payload "$theme" "btop.theme" "$dest/themes/$theme.theme"
  rewrite_line "$dest/btop.conf" 'color_theme = .*' "color_theme = \"$dest/themes/$theme.theme\""
}

apply_glow() {
  local theme="$1"
  local dest="$HOME/.config/glow"
  install_payload "$theme" "glow.json" "$dest/$theme.json"
  rewrite_line "$dest/glow.yml" 'style: .*' "style: $dest/$theme.json"
}

apply_bat() {
  local theme="$1"
  local dest="$HOME/.config/bat"
  install_payload "$theme" "bat.tmTheme" "$dest/themes/$theme.tmTheme"
  rewrite_line "$dest/config" '--theme=".*"' "--theme=\"$theme\""
  run bat cache --build
}

apply_zed() {
  local theme="$1"
  case "$theme" in
    kanagawa) local name="Kanagawa" ;;
    mocha)    local name="Catppuccin Mocha - No Italics" ;;
    *)        local name="$theme" ;;
  esac
  rewrite_line "$HOME/.config/zed/settings.json" '"dark": ".*"' "\"dark\": \"$name\""
}

apply_vscode() {
  local theme="$1"
  case "$theme" in
    kanagawa) local name="Kanagawa" ;;
    mocha)    local name="Catppuccin Mocha" ;;
    *)        local name="$theme" ;;
  esac
  # misc/vscode-settings.json is a settings fragment; edit in place
  local f="$DOTFILES/misc/vscode-settings.json"
  sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$name\"/" "$f"
  sed -i "s/\"workbench.preferredDarkColorTheme\": \".*\"/\"workbench.preferredDarkColorTheme\": \"$name\"/" "$f"
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: sed vscode-settings.json -> $name"
  fi
}

# opencode TUI theme lives in tui.json (string name; built-ins: catppuccin, kanagawa)
apply_opencode() {
  local theme="$1"
  local file="$HOME/.config/opencode/tui.json"
  case "$theme" in
    mocha)    local name="catppuccin" ;;
    kanagawa) local name="kanagawa" ;;
    *)        local name="$theme" ;;
  esac
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: set opencode theme -> $name"
    return
  fi
  mkdir -p "$(dirname "$file")"
  if [ -f "$file" ]; then
    rewrite_line "$file" '"theme"\s*:\s*"[^"]*"' "\"theme\": \"$name\""
  else
    printf '{\n  "$schema": "https://opencode.ai/tui.json",\n  "theme": "%s"\n}\n' "$name" > "$file"
  fi
}

apply_herdr() {
  local theme="$1"
  case "$theme" in
    kanagawa) local name="kanagawa" ;;    mocha)    local name="catppuccin" ;;
    *)        local name="$theme" ;;
  esac
  rewrite_line "$HOME/.config/herdr/config.toml" '^name = ".*"' "name = \"$name\""
}

apply_mako() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/mako/config" "$theme"
}

apply_dunst() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/dunst/dunstrc" "$theme"
}

apply_hyprlock() {
  local theme="$1"
  apply_hyprlock_inline "$HOME/.config/hypr/hyprlock.conf" "$theme"
}

apply_hyprland() {
  local theme="$1"
  # toggle-transparency.sh writes themed borders into /tmp/hypr-opacity.lua
  apply_hyprland_inline "$HOME/.config/hypr/toggle-transparency.sh" "$theme"
  run hyprctl reload
}

apply_gtk() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/gtk-3.0/gtk.css" "$theme"
  apply_palette_inline "$HOME/.config/gtk-4.0/gtk.css" "$theme"
}

apply_lazygit() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/lazygit/config.yml" "$theme"
}

apply_wofi() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/wofi/style.css" "$theme"
}

apply_wlogout() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/wlogout/style.css" "$theme"
}

apply_yazi() {
  local theme="$1"
  apply_palette_inline "$HOME/.config/yazi/theme.toml" "$theme"
}

apply_zsh() {
  local theme="$1"
  apply_palette_inline "$HOME/.zsh/config.zsh" "$theme"
  apply_palette_inline "$HOME/.zsh/prompt.zsh" "$theme"
}

apply_tmux_pick() {
  local theme="$1"
  apply_palette_inline "$DOTFILES/scripts/tmux/tmux-pick.sh" "$theme"
}

apply_gitmux() {
  local theme="$1"
  apply_palette_inline "$HOME/.gitmux.conf" "$theme"
}

apply_statusline() {
  local theme="$1"
  apply_rgb_inline "$HOME/.claude/statusline-command.sh" "$theme"
}

apply_starship() {
  local theme="$1"
  # starship uses inline [palettes.<name>] blocks; flip the active palette line
  case "$theme" in
    mocha)    local pal="catppuccin_mocha" ;;
    kanagawa) local pal="kanagawa" ;;
    *)        local pal="$theme" ;;
  esac
  rewrite_line "$HOME/.config/starship.toml" "^palette = .*" "palette = '$pal'"
}

apply_tmux() {
  local theme="$1"
  # always strip any existing override block, then inject if not mocha
  remove_tmux_thm
  if [ "$theme" != "mocha" ]; then
    inject_tmux_thm "$theme"
  fi
  if [ "${DRY:-0}" != "1" ]; then
    # catppuccin/tmux sets @thm_* with -o (only if unset); drop leftovers so the
    # plugin's own values (or our freshly injected block) take effect on reload
    for v in $(tmux show -g 2>/dev/null | grep '^@thm_' | cut -d' ' -f1); do
      tmux set -ug "$v" 2>/dev/null || true
    done
    tmux source-file "$HOME/.tmux.conf"
  fi
}

# resolve real file so sed -i doesn't replace the stowed symlink
tmux_conf_file() {
  if [ -L "$HOME/.tmux.conf" ]; then
    echo "$(dirname "$(readlink -f "$HOME/.tmux.conf")")/$(basename "$(readlink -f "$HOME/.tmux.conf")")"
  else
    echo "$HOME/.tmux.conf"
  fi
}

remove_tmux_thm() {
  local file="$(tmux_conf_file)"
  local marker="# THEME-SWITCH @thm_* OVERRIDES"
  [ -f "$file" ] || return 0
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: remove tmux @thm_* block"
    return
  fi
  # match one or two leading '#' (new + legacy format); escape the '*' in @thm_*
  sed -i "/^#\{1,2\} \{0,1\}THEME-SWITCH @thm_\* OVERRIDES\$/,/^# END THEME-SWITCH\$/d" "$file"
  # strip trailing blank lines left behind by inject/remove
  sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$file"
}

# catppuccin/tmux only ships catppuccin flavors; for other palettes inject
# @thm_* hex overrides. mocha needs none (plugin provides them natively).
inject_tmux_thm() {
  local theme="$1"
  local file="$(tmux_conf_file)"
  local marker="# THEME-SWITCH @thm_* OVERRIDES"
  local mocha_palette="$PALETTES_DIR/mocha.palette"
  local theme_palette="$PALETTES_DIR/$theme.palette"

  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: rewrite tmux @thm_* block ($theme)"
    return
  fi

  local lines=("" "$marker")
  local name mocha_hex theme_hex
  while IFS== read -r name mocha_hex; do
    [ -n "$name" ] || continue
    theme_hex="$(grep -m1 "^${name}=" "$theme_palette" | cut -d= -f2)"
    [ -n "$theme_hex" ] || continue
    lines+=("set -g @thm_${name} \"#${theme_hex}\"")
  done < "$mocha_palette"
  # catppuccin/tmux uses snake_case for a few names; emit both forms
  for n in surface0 surface1 surface2 overlay0 overlay1 overlay2 subtext0 subtext1; do
    local stem="${n//[0-9]/}"
    local hex="$(grep -m1 "^${n}=" "$theme_palette" | cut -d= -f2)"
    [ -n "$hex" ] && lines+=("set -g @thm_${stem}_${n##*[a-z]} \"#${hex}\"")
  done
  # plugin's canonical bg/fg names come from base/text palette keys
  local base_hex="$(grep -m1 '^base=' "$theme_palette" | cut -d= -f2)"
  local text_hex="$(grep -m1 '^text=' "$theme_palette" | cut -d= -f2)"
  lines+=("set -g @thm_bg \"#${base_hex}\"")
  lines+=("set -g @thm_fg \"#${text_hex}\"")
  lines+=("# END THEME-SWITCH" "")
  printf '%s\n' "${lines[@]}" >> "$file"
}

apply_nvim() {
  local theme="$1"
  for cfg in "$DOTFILES/nvim-configs"/*/; do
    [ -d "$cfg" ] || continue
    cfg="${cfg%/}"
    name="$(basename "$cfg")"
    case "$name" in
      custom-nvchad) apply_nvchad "$name" "$theme" ;;
      *)             apply_nvim_payload "$name" "$theme" ;;
    esac
  done
}

# swap colors.lua payload for configs using catppuccin/kanagawa.nvim
apply_nvim_payload() {
  local cfg="$1" theme="$2"
  local payload="$THEMES_DIR/$theme/nvim/$cfg.lua"
  [ -f "$payload" ] || { echo "  warn: no nvim payload for $cfg ($theme)" >&2; return 0; }
  # locate the config's colors.lua that references the colorscheme plugin
  local found=""
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    if grep -qE 'catppuccin/nvim|rebelot/kanagawa.nvim' "$f" 2>/dev/null; then
      found="$f"
      break
    fi
  done < <(find "$DOTFILES/nvim-configs/$cfg" -name "*.lua" -type f)
  if [ -n "$found" ]; then
    run cp "$payload" "$found"
  fi
}

# custom-nvchad uses base46's built-in theme name
apply_nvchad() {
  local cfg="$1" theme="$2"
  local file="$DOTFILES/nvim-configs/$cfg/lua/nvconfig.lua"
  case "$theme" in
    mocha)    local base46="catppuccin" ;;
    kanagawa) local base46="kanagawa" ;;
    *)        local base46="$theme" ;;
  esac
  # only the base46 theme under M.base46, not the cheatsheet theme below
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: sed nvconfig.lua base46 theme -> $base46"
    return
  fi
  sed -i '/M\.base46 = {/,/^}/s/^  theme = ".*",$/  theme = "'"$base46"'",/' "$file"
}

# Zen Browser userChrome.css (payloads themes/{theme}/zen.css)
apply_zen() {
  local theme="$1"
  local dest="$HOME/.zen/$ZEN_PROFILE/chrome/userChrome.css"
  [ -f "$THEMES_DIR/$theme/zen.css" ] || { echo "  warn: no zen payload for $theme" >&2; return 0; }
  mkdir -p "$(dirname "$dest")"
  install_payload "$theme" "zen.css" "$dest"
}

# ---- palette substitution -------------------------------------------------

# resolve to the real file so sed -i doesn't replace a stowed symlink
resolve_file() {
  readlink -f "$1" 2>/dev/null || echo "$1"
}

# build mocha->theme sed -e args for the given color syntax
from_to_args() {
  local from_palette="$1" to_palette="$2" kind="$3"
  local args=() name from_hex to_hex from_val to_val
  while IFS== read -r name from_hex; do
    # skip empty lines and comments
    [ -n "$name" ] || continue
    [[ "$name" == \#* ]] && continue
    [ -n "$from_hex" ] || continue
    to_hex="$(grep -m1 "^${name}=" "$to_palette" | cut -d= -f2)"
    [ -n "$to_hex" ] || continue
    [ "$from_hex" != "$to_hex" ] || continue
    case "$kind" in
      hex)      from_val="#${from_hex}"; to_val="#${to_hex}" ;;
      rgb)      from_val="$(printf '%d;%d;%d' 0x${from_hex:0:2} 0x${from_hex:2:2} 0x${from_hex:4:2})"
                to_val="$(printf '%d;%d;%d' 0x${to_hex:0:2} 0x${to_hex:2:2} 0x${to_hex:4:2})" ;;
      hyprlock) from_val="$(printf 'rgb(%d,%d,%d)' 0x${from_hex:0:2} 0x${from_hex:2:2} 0x${from_hex:4:2})"
                to_val="$(printf 'rgb(%d,%d,%d)' 0x${to_hex:0:2} 0x${to_hex:2:2} 0x${to_hex:4:2})" ;;
      hyprland) from_val="rgb(${from_hex})"; to_val="rgb(${to_hex})" ;;
    esac
    args+=("-e" "s|${from_val}|${to_val}|g")
    if [ "$kind" = "hyprlock" ]; then
      from_val="$(printf 'rgba(%d,%d,%d)' 0x${from_hex:0:2} 0x${from_hex:2:2} 0x${from_hex:4:2})"
      to_val="$(printf 'rgba(%d,%d,%d)' 0x${to_hex:0:2} 0x${to_hex:2:2} 0x${to_hex:4:2})"
      args+=("-e" "s|${from_val}|${to_val}|g")
    fi
  done < "$from_palette"
  printf '%s\n' "${args[@]}"
}

# map a live config path to its repo-relative mocha master under themes/mocha/inline
inline_master() {
  local path="$(resolve_file "$1")"
  local rel="${path#$DOTFILES/}"
  if [ "$rel" = "$path" ]; then
    case "$path" in
      "$HOME"/*) rel="${path#$HOME/}" ;;
      *)         echo ""; return 1 ;;
    esac
  fi
  echo "$THEMES_DIR/mocha/inline/$rel"
}

# copy the mocha master over the live file, then apply mocha->theme sed.
# masters are authoritative, so round-trips are lossless (no current-state sed).
apply_theme_inline() {
  local file="$(resolve_file "$1")" theme="$2" kind="$3"
  local master="$(inline_master "$file")"
  [ -f "$master" ] || return 0
  [ -f "$PALETTES_DIR/$theme.palette" ] || return 0
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: render $file from master ($theme)"
    return
  fi
  if [ "$theme" = "$DEFAULT_THEME" ]; then
    cp -f "$master" "$file"
  else
    local args=()
    mapfile -t args < <(from_to_args "$PALETTES_DIR/$DEFAULT_THEME.palette" "$PALETTES_DIR/$theme.palette" "$kind")
    sed "${args[@]}" "$master" > "$file"
  fi
}

# apply hex substitution for a target theme onto an existing file
apply_palette_inline() {
  apply_theme_inline "$1" "$2" hex
}

# same, but for ANSI 24-bit RGB triplets (R;G;B)
apply_rgb_inline() {
  apply_theme_inline "$1" "$2" rgb
}

# hyprlock uses rgb(r,g,b) / rgba(r,g,b,a) syntax
apply_hyprlock_inline() {
  apply_theme_inline "$1" "$2" hyprlock
}

# hyprland col.active_border accepts rgb(HEX) (hex without '#')
apply_hyprland_inline() {
  apply_theme_inline "$1" "$2" hyprland
}

# ---- apply ----------------------------------------------------------------

reload_apps() {
  # restart services + reload shells
  if has_cmd systemctl; then
    run systemctl --user restart mako.service 2>/dev/null || true
    run systemctl --user restart waybar.service 2>/dev/null || true
    run systemctl --user restart dunst.service 2>/dev/null || true
  fi
  if has_cmd hyprctl; then
    run hyprctl reload >/dev/null 2>&1 || true
  fi
  reload_terminals
}

# pick a random wallpaper from the active theme's subdir and apply it.
# falls back to the theme's root dir if the subdir is missing.
apply_wallpaper() {
  local theme="$1"
  local wall_dir="$HOME/wallpapers/$theme"
  local picker="$HOME/.config/hypr/set-wallpaper.sh"

  [ -d "$wall_dir" ] || wall_dir="$HOME/wallpapers"

  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: random wallpaper from $wall_dir"
    return
  fi

  if [ -d "$wall_dir" ] && has_cmd hyprctl && [ -x "$picker" ]; then
    "$picker" >/dev/null 2>&1 || true
  fi
}

# terminals pick up the new theme live:
#   kitty    SIGUSR1 reloads config
#   ghostty  SIGUSR2 reloads config (1.3+)
#   alacritty live_config_reload already watches the config file
reload_terminals() {
  if [ "${DRY:-0}" = "1" ]; then
    echo "  DRY: reload terminals"
    return
  fi
  if has_cmd kitty && pgrep -x kitty >/dev/null 2>&1; then
    pkill -USR1 -x kitty 2>/dev/null || true
  fi
  if has_cmd ghostty && pgrep -x ghostty >/dev/null 2>&1; then
    pkill -USR2 -x ghostty 2>/dev/null || true
  fi
}

apply_theme() {
  local theme="$1"
  [ -f "$PALETTES_DIR/$theme.palette" ] || die "unknown theme '$theme'"

  notify_start "$theme"

  apply_kitty "$theme" || true
  apply_ghostty "$theme" || true
  apply_alacritty "$theme" || true
  apply_wezterm "$theme" || true
  apply_helix "$theme" || true
  apply_zellij "$theme" || true
  apply_rofi "$theme" || true
  apply_waybar "$theme" || true
  apply_btop "$theme" || true
  apply_glow "$theme" || true
  apply_bat "$theme" || true
  apply_zed "$theme" || true
  apply_vscode "$theme" || true
  apply_opencode "$theme" || true
  apply_herdr "$theme" || true
  apply_mako "$theme" || true
  apply_dunst "$theme" || true
  apply_hyprlock "$theme" || true
  apply_hyprland "$theme" || true
  apply_gtk "$theme" || true
  apply_lazygit "$theme" || true
  apply_wofi "$theme" || true
  apply_wlogout "$theme" || true
  apply_yazi "$theme" || true
  apply_zsh "$theme" || true
  apply_tmux_pick "$theme" || true
  apply_gitmux "$theme" || true
  apply_statusline "$theme" || true
  apply_starship "$theme" || true
  apply_tmux "$theme" || true
  apply_nvim "$theme" || true
  apply_zen "$theme" || true

  notify_processing "$theme"

  if [ "${DRY:-0}" != "1" ]; then
    printf '%s\n' "$theme" > "$STATE_FILE"
    reload_apps
    apply_wallpaper "$theme"
  fi
  echo "Applied theme: $theme"
  notify_done "$theme"
}

# copy the current live configs (in mocha state) into themes/mocha/inline/
# so apply can always regenerate losslessly. Run after editing a config.
sync_masters() {
  local target
  for target in \
    "$HOME/.config/mako/config" \
    "$HOME/.config/dunst/dunstrc" \
    "$HOME/.config/hypr/hyprlock.conf" \
    "$HOME/.config/hypr/toggle-transparency.sh" \
    "$HOME/.config/gtk-3.0/gtk.css" \
    "$HOME/.config/gtk-4.0/gtk.css" \
    "$HOME/.config/lazygit/config.yml" \
    "$HOME/.config/waybar/config.jsonc" \
    "$HOME/.config/waybar/sway-config.jsonc" \
    "$HOME/.config/wofi/style.css" \
    "$HOME/.config/wlogout/style.css" \
    "$HOME/.config/yazi/theme.toml" \
    "$HOME/.zsh/config.zsh" \
    "$HOME/.zsh/prompt.zsh" \
    "$DOTFILES/scripts/tmux/tmux-pick.sh" \
    "$HOME/.gitmux.conf" \
    "$HOME/.claude/statusline-command.sh"
  do
    [ -f "$target" ] || continue
    local master="$(inline_master "$target")"
    [ -n "$master" ] || continue
    mkdir -p "$(dirname "$master")"
    cp -f "$target" "$master"
    echo "master: $master"
  done
}

# ---- main -----------------------------------------------------------------

CMD="${1:-}"
shift || true

case "$CMD" in
  list)    list_themes ;;
  current) current_theme ;;
  apply)
    theme="${1:-}"
    [ -n "$theme" ] || usage
    if [ "${2:-}" = "--dry" ] || [ "$theme" = "--dry" ]; then DRY=1; theme="${theme/--dry/}"; fi
    apply_theme "$theme"
    ;;
  pick)
    exec "$(dirname "$0")/theme-pick.sh"
    ;;
  sync-masters)
    sync_masters
    ;;
  *) usage ;;
esac
