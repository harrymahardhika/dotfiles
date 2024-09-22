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
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done

OS=$(get_os)

# Launch picom with settings based on the detected distro
case "$OS" in
  pop)
    echo "Detected PopOS. Launching picom with Ubuntu-specific settings..."
    picom --config $HOME/.config/picom/picom.conf --experimental-backends &
    ;;
  ubuntu)
    echo "Detected Ubuntu. Launching picom with Ubuntu-specific settings..."
    picom --config $HOME/.config/picom/picom.conf &
    ;;
  arch)
    echo "Detected Arch Linux. Launching picom with Arch-specific settings..."
    picom --config $HOME/.config/picom/picom.conf &
    ;;
  *)
    echo "Unknown or unsupported distro. Launching picom with default settings..."
    picom --config $HOME/.config/picom/picom.conf &
    ;;
esac

# Optional: Log the output to a file
echo "Picom launched for $OS" | tee -a /tmp/picom_launch.log
