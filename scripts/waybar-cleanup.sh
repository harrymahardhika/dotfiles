#!/usr/bin/env bash
# Kill duplicate waybar instances, keeping only the one managed by systemd

# Get all waybar PIDs
mapfile -t pids < <(pgrep -x waybar)

# If there's more than one instance
if [ ${#pids[@]} -gt 1 ]; then
  echo "Found ${#pids[@]} waybar instances. Cleaning up..."
  
  # Get the systemd-managed waybar PID
  systemd_pid=$(systemctl --user show -p MainPID --value waybar 2>/dev/null)
  
  # Kill all instances except the systemd one
  for pid in "${pids[@]}"; do
    if [ "$pid" != "$systemd_pid" ] && [ -n "$pid" ] && [ "$pid" -gt 0 ]; then
      echo "Killing duplicate waybar instance: $pid"
      kill -9 "$pid" 2>/dev/null || true
    fi
  done
  
  echo "Cleanup complete. Only systemd waybar (PID: $systemd_pid) should be running."
elif [ ${#pids[@]} -eq 1 ]; then
  echo "Only one waybar instance running (PID: ${pids[0]}). All good!"
else
  echo "No waybar instances running."
fi
