phpserver () {
  local port="${1:-0}"
  php -S "localhost:800$port"
}
alias sv=phpserver

