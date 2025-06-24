#!/usr/bin/env sh

get_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "unknown"
  fi
}

# Kill any existing picom processes
killall -q picom

# Wait until the processes have been shut down
# while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
sleep 0.5

OS=$(get_os)

# Launch picom with settings based on the detected distro
case "$OS" in
  pop)
    picom --config $HOME/.config/picom/picom.conf --experimental-backends &
    ;;
  *)
    # picom --config $HOME/.config/picom/picom.conf &
    picom --config ~/.config/picom/picom.conf --log-level=debug --log-file=~/.cache/picom.log &
    ;;
esac

# Optional: Log the output to a file
echo "Picom launched for $OS" | tee -a /tmp/picom_launch.log
