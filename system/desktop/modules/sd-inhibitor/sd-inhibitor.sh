mkdir -p "/tmp/icedos"
lock="/tmp/icedos/lock"

command -v cpu-watcher &>/dev/null && CPU_WATCHER="true"
command -v disk-watcher &>/dev/null && DISK_WATCHER="true"
command -v network-watcher &>/dev/null && NETWORK_WATCHER="true"
command -v pipewire-watcher &>/dev/null && PIPEWIRE_WATCHER="true"

while true; do
  if [[ "$PIPEWIRE_WATCHER" == "true" && `pipewire-watcher` = "true" ]]; then
    if [ "$LAST_PIPEWIRE_PID" == "" ]; then
      systemd-inhibit --what="idle" --why="pipewire has active nodes" sh -c "while :; do sleep 1; done" &
      LAST_PIPEWIRE_PID="$!"
      echo "$LAST_PIPEWIRE_PID" > "$lock"
    fi
  elif [ "$LAST_PIPEWIRE_PID" != "" ]; then
    kill -9 "$LAST_PIPEWIRE_PID"
    LAST_PIPEWIRE_PID=""
    echo "" > "$lock"
  fi

  [[ "$CPU_WATCHER" == "true" && `cpu-watcher` = "true" ]] && cpu="cpu " || cpu=""
  [[ "$DISK_WATCHER" == "true" && `disk-watcher` = "true" ]] && disk="disk " || disk=""
  [[ "$NETWORK_WATCHER" == "true" && `network-watcher` = "true" ]] && network="network " || network=""

  if [[ "$cpu" != "" || "$disk" != "" || "$network" != "" ]]; then
    if [ "$LAST_DEVICES_PID" == "" ]; then
      systemd-inhibit --what="sleep:shutdown" --why="$network$cpu${disk}beyond usage limit" sh -c "while :; do sleep 1; done" &
      LAST_DEVICES_PID="$!"
    fi
  elif [ "$LAST_DEVICES_PID" != "" ]; then
    kill -9 "$LAST_DEVICES_PID"
    LAST_DEVICES_PID=""
  fi
done
