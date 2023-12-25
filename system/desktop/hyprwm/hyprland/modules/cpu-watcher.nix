{ pkgs, config }:
pkgs.writeShellScriptBin "cpu-watcher" ''
  UTILIZATION="$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))"
  CPU_THRESOLD=${config.desktop.hyprland.lock.cpuUsageThreshold}

  if (( UTILIZATION > CPU_THRESOLD )) then
      printf true
  else
      printf false
  fi
''
