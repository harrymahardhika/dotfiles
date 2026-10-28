#!/usr/bin/env bash
set -euo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

die() { echo "Error: $*" >&2; exit 1; }

command -v fzf >/dev/null 2>&1 || die "fzf is required but not installed."
command -v tmux >/dev/null 2>&1 || die "tmux is required but not installed."

# ── list functions ──────────────────────────────────────────────────────────

# Emits: kind(S|W) <TAB> session <TAB> window_index <TAB> display line
# Sessions are group headers; their windows are tree children.
list() {
  local exclude="${TMUX_PICK_EXCLUDE:-^(popup|scratch|temp)$}"
  local cur_sess cur_win
  cur_sess=$(tmux display -p '#{session_name}' 2>/dev/null || true)
  cur_win=$(tmux display -p '#{window_index}' 2>/dev/null || true)

  tmux list-windows -a -F $'#{session_name}\t#{window_index}\t#{window_name}\t#{session_activity}' 2>/dev/null | \
    awk -F $'\t' -v cs="$cur_sess" -v ex="$exclude" 'BEGIN{OFS="\t"} $1 !~ ex {print ($1==cs ? 0 : 1), 0-$4, $0}' | \
    sort -t$'\t' -k1,1n -k2,2n -k3,3 -k4,4n | cut -f3- | \
    awk -F $'\t' -v cs="$cur_sess" -v cw="$cur_win" 'BEGIN{OFS="\t"}
      { n++; sess[n]=$1; idx[n]=$2; name[n]=$3 }
      END {
        B = sprintf("%c[1m", 27); D = sprintf("%c[2m", 27); R = sprintf("%c[0m", 27)
        for (i = 1; i <= n; i++) {
          if (sess[i] != sess[i-1]) print "S", sess[i], "", B sess[i] R
          last = (sess[i+1] != sess[i])
          cur = (sess[i] == cs && idx[i] + 0 == cw + 0)
          print "W", sess[i], idx[i], D (last ? "└─ " : "├─ ") R (cur ? "▶ " : "  ") D sess[i] ": " R name[i]
        }
      }' || true
}

# ── subcommands ─────────────────────────────────────────────────────────────

if [ "${1:-}" = "list" ]; then
  list
  exit 0
fi

# ── outside tmux → session picker ──────────────────────────────────────────

if [ -z "${TMUX:-}" ]; then
  sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null) || die "No tmux sessions found."
  [ -z "$sessions" ] && die "No tmux sessions found."

  sel=$(echo "$sessions" | fzf \
    --prompt='❯ ' --reverse \
    --color=bg+:#2a2a37,bg:#1f1f28,spinner:#dcd7ba,hl:#e46876 \
    --color=fg:#dcd7ba,header:#e46876,info:#7aa89f,pointer:#dcd7ba \
    --color=marker:#8992b2,fg+:#dcd7ba,prompt:#7aa89f,hl+:#e46876 \
    --color=selected-bg:#2a2a37 --color=border:#2a2a37,label:#dcd7ba \
    || true)

  [ -z "${sel:-}" ] && exit 0
  exec tmux attach -t "$sel"
fi

# ── inside tmux → session/window picker ────────────────────────────────────

sel=$(
  list | fzf \
  -d $'\t' \
  --with-nth=4 --ansi \
  --prompt='❯ ' --reverse \
  --bind='ctrl-r:execute-silent(if [ "{1}" = W ]; then tmux command-prompt -p "Rename window:" "rename-window -t {2}:{3} %1"; fi)+reload:'"$SELF list" \
  --bind='ctrl-k:execute-silent(if [ "{1}" = W ]; then tmux kill-window -t {2}:{3}; fi)+reload:'"$SELF list" \
  --color=bg+:#2a2a37,bg:#1f1f28,spinner:#dcd7ba,hl:#e46876 \
  --color=fg:#dcd7ba,header:#e46876,info:#7aa89f,pointer:#dcd7ba \
  --color=marker:#8992b2,fg+:#dcd7ba,prompt:#7aa89f,hl+:#e46876 \
  --color=selected-bg:#2a2a37 --color=border:#2a2a37,label:#dcd7ba \
  || true
)

[ -z "${sel:-}" ] && exit 0

IFS=$'\t' read -r kind sess win _ <<< "$sel"

if [ "$kind" = S ]; then
  exec tmux switch-client -t "$sess"
elif tmux list-windows -t "$sess" -F '#{window_index}' 2>/dev/null | grep -qFx "$win"; then
  exec tmux switch-client -t "$sess:$win"
else
  die "Window '$sess:$win' not found"
fi
