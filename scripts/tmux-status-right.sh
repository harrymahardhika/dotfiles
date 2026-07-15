#!/usr/bin/env bash
# Builds tmux status-right, only inserting separators between segments
# that actually produced output (e.g. skips the divider when the current
# pane isn't inside a git repo).

pane_path="$1"

overlay=$(tmux show -gqv @thm_overlay_2)
text=$(tmux show -gqv @thm_fg)
sep=" #[fg=${overlay}]│#[fg=${text}] "

segments=()

git=$(gitmux -cfg "$HOME/.gitmux.conf" "$pane_path" 2>/dev/null)
[ -n "$git" ] && segments+=("$git")

battery=$(~/scripts/tmux-battery.sh)
[ -n "$battery" ] && segments+=("#[fg=${text}]${battery}")

segments+=("#[fg=${text}]󰥔 $(date +%H:%M)")

out=""
for seg in "${segments[@]}"; do
    if [ -z "$out" ]; then
        out="$seg"
    else
        out="${out}${sep}${seg}"
    fi
done

printf '%s ' "$out"
