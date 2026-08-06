#!/usr/bin/env sh
# reload-tmux-theme.sh — reload the tmux config and re-exec every idle zsh
# prompt so the new palette shows up in already-open sessions.
#
# Source this file to define reload_tmux_theme(), or run it directly:
#   reload-tmux-theme.sh
#
# Env:
#   TMUX_CONF   tmux config to source (default: ~/.config/tmux/tmux.conf when
#               present, else ~/.tmux.conf)
reload_tmux_theme() {
    (
        # no tmux binary, or the server isn't running -> nothing to do
        command -v tmux >/dev/null 2>&1 || exit 0
        tmux has-session >/dev/null 2>&1 || exit 0

        conf="${TMUX_CONF:-}"
        if [ -z "$conf" ]; then
            if [ -f "$HOME/.config/tmux/tmux.conf" ]; then
                conf="$HOME/.config/tmux/tmux.conf"
            elif [ -f "$HOME/.tmux.conf" ]; then
                conf="$HOME/.tmux.conf"
            fi
        fi

        if [ -n "$conf" ]; then
            tmux source-file "$conf" || {
                echo "reload_tmux_theme: failed to source $conf" >&2
                exit 1
            }
        fi

        # redraw every attached client so the new status line appears now
        for client in $(tmux list-clients -F '#{client_name}' 2>/dev/null); do
            tmux refresh-client -S -t "$client" >/dev/null 2>&1 || true
        done

        # re-exec each idle zsh prompt (`exec zsh` keeps the pane's PID stable).
        # tmux -F does not expand \t, so pass a real tab byte as the separator.
        # Re-check the pane right before sending: it may have closed or started
        # a foreground job since the snapshot — never send to a non-zsh pane.
        tab="$(printf '\t')"
        tmux list-panes -a -F "#{pane_id}${tab}#{pane_current_command}" 2>/dev/null |
            while IFS="$tab" read -r pane cmd; do
                [ "$cmd" = "zsh" ] || continue
                cmd_now="$(tmux display-message -p -t "$pane" -F '#{pane_current_command}' 2>/dev/null)" || cmd_now=""
                [ "$cmd_now" = "zsh" ] || continue
                # Mirror the pane's login-shell status: plain `exec zsh` would
                # silently downgrade a login shell (e.g. the 'popup' session
                # runs `zsh -l`) to non-login, dropping .zprofile/.zlogin env.
                # Detect via the pane process argv: a leading '-' on argv[0]
                # or a -l/-L/--login flag means login. No tmux format exposes
                # this, so read the pane PID's cmdline; falls back to
                # non-login if /proc is unavailable.
                login=0
                pane_pid="$(tmux display-message -p -t "$pane" -F '#{pane_pid}' 2>/dev/null)" || pane_pid=""
                if [ -n "$pane_pid" ] && [ -r "/proc/${pane_pid}/cmdline" ]; then
                    argv="$(tr '\0' ' ' < "/proc/${pane_pid}/cmdline" 2>/dev/null)" || argv=""
                    case "$argv" in
                        "-"*|*" -l"*|*" -L"*|*" --login"*) login=1 ;;
                    esac
                fi
                if [ "$login" = "1" ]; then
                    tmux send-keys -t "$pane" "exec zsh -l" Enter >/dev/null 2>&1 || true
                else
                    tmux send-keys -t "$pane" "exec zsh" Enter >/dev/null 2>&1 || true
                fi
            done
    )
}

case "${0##*/}" in
    reload-tmux-theme.sh) reload_tmux_theme ;;
esac
