#!/usr/bin/env bash
set -euo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

die() { echo "Error: $*" >&2; exit 1; }

command -v fzf >/dev/null 2>&1 || die "fzf is required but not installed."
command -v tmux >/dev/null 2>&1 || die "tmux is required but not installed."

# ── list functions ──────────────────────────────────────────────────────────

list() {
  local exclude="${TMUX_PICK_EXCLUDE:-^(popup|scratch|temp)$}"
  local cur_sess cur_win

  local current
  current=$(tmux display -p $'C\t#{session_name}\t#{window_index}' 2>/dev/null) || current=$'C\t\t'
  IFS=$'\t' read -r _ cur_sess cur_win <<< "$current"

  tmux list-windows -a -F $'W\t#{session_name}\t#{window_index}\t#{window_activity}\t#{session_name}:#{window_index} #{window_name}' 2>/dev/null | \
    awk -F $'\t' \
      -v exclude="$exclude" \
      -v cur_sess="$cur_sess" \
      -v cur_win="$cur_win" \
      'BEGIN{OFS="\t"}
       $2 !~ exclude {
         is_cur = ($2 == cur_sess && $3+0 == cur_win+0)
         sk = is_cur ? "1" : "2"
         prefix = is_cur ? "▶ " : "  "
         print sk, $1, $2, $3, $4, prefix $5
       }' || true
}

list_sorted() {
  list | sort -t$'\t' -k3,3 -k1,1n -k5,5rn
}

# ── subcommands ─────────────────────────────────────────────────────────────

if [ "${1:-}" = "list" ]; then
  list_sorted
  exit 0
fi

# ── outside tmux → session picker ──────────────────────────────────────────

if [ -z "${TMUX:-}" ]; then
  sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null) || die "No tmux sessions found."
  [ -z "$sessions" ] && die "No tmux sessions found."

  sel=$(echo "$sessions" | fzf \
    --prompt='❯ ' --reverse \
    --color=bg+:#16161d,bg:#1f1f28,spinner:#dcd7ba,hl:#e46876 \
    --color=fg:#dcd7ba,header:#e46876,info:#957fb8,pointer:#dcd7ba \
    --color=marker:#8992b2,fg+:#dcd7ba,prompt:#957fb8,hl+:#e46876 \
    --color=selected-bg:#2a2a37 --color=border:#16161d,label:#dcd7ba \
    || true)

  [ -z "${sel:-}" ] && exit 0
  exec tmux attach -t "$sel"
fi

# ── inside tmux → window picker ────────────────────────────────────────────

sel=$(
  list_sorted | fzf \
  -d $'\t' \
  --with-nth=6.. --ansi \
  --prompt='❯ ' --reverse \
  --bind='ctrl-r:execute-silent(if [ -n "{4}" ]; then tmux command-prompt -p "Rename window:" "rename-window -t {3}:{4} %1"; fi)+reload:'"$SELF list" \
  --bind='ctrl-k:execute-silent(if [ -n "{4}" ]; then tmux kill-window -t {3}:{4}; fi)+reload:'"$SELF list" \
  --color=bg+:#16161d,bg:#1f1f28,spinner:#dcd7ba,hl:#e46876 \
  --color=fg:#dcd7ba,header:#e46876,info:#957fb8,pointer:#dcd7ba \
  --color=marker:#8992b2,fg+:#dcd7ba,prompt:#957fb8,hl+:#e46876 \
  --color=selected-bg:#2a2a37 --color=border:#16161d,label:#dcd7ba \
  || true
)

[ -z "${sel:-}" ] && exit 0

IFS=$'\t' read -r _ type sess win _ _ <<< "$sel"

if tmux list-windows -t "$sess" -F '#{window_index}' 2>/dev/null | grep -qFx "$win"; then
  exec tmux switch-client -t "$sess:$win"
else
  die "Window '$sess:$win' not found"
fi
