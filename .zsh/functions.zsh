phpserver () {
  local port="${1:-0}"
  php -S "localhost:800$port"
}
alias sv=phpserver

sudo() {
  # If credentials are cached, no prompt needed.
  if ! command sudo -n true 2>/dev/null; then
    command -v notify-send >/dev/null && \
      notify-send -u critical "sudo password required" "Command: $*"
    printf '\a'  # terminal bell
  fi
  command sudo "$@"
}

