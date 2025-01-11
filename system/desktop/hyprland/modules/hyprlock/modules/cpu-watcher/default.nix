{
  pkgs,
  config,
  ...
}:

let
  cfg = config.icedos;
  threshold = builtins.toString (cfg.desktop.hyprland.lock.cpuUsageThreshold);
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "cpu-watcher" ''
      UTILIZATION="$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))"
      CPU_THRESOLD=${threshold}

      if (( UTILIZATION > CPU_THRESOLD )) then
          printf true
      else
          printf false
      fi
    '')
  ];
}
