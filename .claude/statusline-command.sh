#!/usr/bin/env bash
# Claude Code status line - mirrors ~/.zsh/prompt.zsh (Catppuccin Mocha)

input=$(cat)

# Catppuccin Mocha palette (ANSI 24-bit)
blue="\033[38;2;126;156;216m"
yellow="\033[38;2;230;195;132m"
green="\033[38;2;152;187;108m"
sapphire="\033[38;2;106;149;137m"
lavender="\033[38;2;137;146;178m"
mauve="\033[38;2;149;127;184m"
red="\033[38;2;228;104;118m"
peach="\033[38;2;255;160;102m"
overlay0="\033[38;2;84;84;109m"
reset="\033[0m"

sep=" ${overlay0} ${reset} "

# Nerd Font icons (Font Awesome codepoints)
icon_dir=$'󰇐'
icon_model=$'󰧑'
icon_ctx=$'󰮰'
icon_5h=$''
icon_7d=$''
icon_git=$''

# Single jq call for all fields (avoids five separate forks per render)
IFS=$'\t' read -r cwd model used_pct five_hour_pct seven_day_pct <<< "$(jq -r '
  [.cwd,
   (.model.display_name // empty),
   (.context_window.used_percentage // empty),
   (.rate_limits.five_hour.used_percentage // empty),
   (.rate_limits.seven_day.used_percentage // empty)] | @tsv
' <<< "$input")"

# Directory (just the current folder name, or ~ for $HOME, or / for root)
if [ "$cwd" = "$HOME" ]; then
  short_dir="~"
elif [ "$cwd" = "/" ]; then
  short_dir="/"
else
  short_dir="${cwd##*/}"
fi

# Directory segment
printf "${blue}${icon_dir} %s${reset}" "$short_dir"

# Git branch segment (only inside a work tree)
branch=$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  dirty=""
  git -C "$cwd" diff --quiet 2>/dev/null || dirty="*"
  git -C "$cwd" diff --cached --quiet 2>/dev/null || dirty="${dirty}+"
  printf "${sep}${peach}${icon_git} %s${reset}" "${branch}${dirty}"
fi

# Model segment
printf "${sep}${sapphire}${icon_model} %s${reset}" "$model"

# Context usage segment (only shown after first message)
# Color-coded: green under 70%, yellow 70-89%, red 90%+
if [ -n "$used_pct" ]; then
  used_pct_int=${used_pct%.*}
  if [ "$used_pct_int" -ge 90 ]; then
    ctx_color="$red"
  elif [ "$used_pct_int" -ge 70 ]; then
    ctx_color="$yellow"
  else
    ctx_color="$green"
  fi
  printf "${sep}${ctx_color}${icon_ctx} ctx → %.0f%%${reset}" "$used_pct"
fi

# Plan usage segment (5h/7d limits, only shown when the fields are present)
if [ -n "$five_hour_pct" ]; then
  printf "${sep}${green}${icon_5h} 5h → %.0f%%${reset}" "$five_hour_pct"
fi
if [ -n "$seven_day_pct" ]; then
  printf "${sep}${green}${icon_7d} 7d → %.0f%%${reset}" "$seven_day_pct"
fi

