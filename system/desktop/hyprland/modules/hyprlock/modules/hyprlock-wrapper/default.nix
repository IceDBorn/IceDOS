{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "hyprlock-wrapper" ''
      if [ `pipewire-watcher` = "true" ] && [ -z $2 ]; then exit; fi

      if [[ "$1" == "lock" ]]; then
        hyprlock
        exit
      elif [[ "$1" == "off" ]]; then
        hyprctl dispatch dpms off
        exit
      fi

      if [ `network-watcher` = "true" ]; then exit; fi
      if [ `cpu-watcher` = "true" ]; then exit; fi
      if [ `disk-watcher` = "true" ]; then exit; fi

      if [[ "$1" == "suspend" ]]; then
        systemctl suspend
      fi
    '')
  ];
}
