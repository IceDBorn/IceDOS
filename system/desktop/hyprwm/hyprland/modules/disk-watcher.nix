{ pkgs, config }:
pkgs.writeShellScriptBin "disk-watcher" ''
  DISKS=($(lsblk -d -io NAME | tail -n +2))
  READ_QUERY=".sysstat.hosts[].statistics[].disk[].MB_read"
  WRITE_QUERY=".sysstat.hosts[].statistics[].disk[].MB_wrtn"
  DISK_THRESHOLD=${config.desktop.hyprland.lock.diskUsageThreshold}

  diskstats () {
    iostat -d -m -z -o JSON "$1"
  }

  read=()
  written=()
  for disk in "''${DISKS[@]}"
  do
    json="$(diskstats "$disk")"
    read+=($(echo "$json" | jq "$READ_QUERY"))
    written+=($(echo "$json" | jq "$WRITE_QUERY"))
  done

  sleep 1

  i=0
  for disk in "''${DISKS[@]}"
  do
    json="$(diskstats "$disk")"
    current_read=($(echo "$json" | jq "$READ_QUERY"))
    current_written=($(echo "$json" | jq "$WRITE_QUERY"))

    READ_PER_SECOND=$(( current_read - read[i] ))
    WRITE_PER_SECOND=$(( current_written - written[i] ))

    if (( READ_PER_SECOND > DISK_THRESHOLD )) || (( WRITE_PER_SECOND > DISK_THRESHOLD )); then
      printf true
      exit
    fi
    ((i++))
  done

  printf false
''
