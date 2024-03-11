{ pkgs }:
pkgs.writeShellScriptBin "swaylock-wrapper" ''
    if [ `pipewire-watcher` = "true" ] && [ -z $2 ]; then exit; fi

    if [[ "$1" == "lock" ]]; then
      swaylock --daemonize \
      --clock \
      --indicator-idle-visible \
      --fade-in 4 \
      --grace 5 \
      --screenshots \
      --effect-blur 10x10 \
      --inside-color 00000055 \
      --text-color F \
      --ring-color F \
      --effect-vignette 0.2:0.2
      exit
  elif [[ "$1" == "off" ]]; then
    hyprctl dispatch dpms off
    exit
  elif [[ "$1" == "on" ]]; then
    hyprctl dispatch dpms on
    exit
  fi

  if [ `network-watcher` = "true" ]; then exit; fi
  if [ `cpu-watcher` = "true" ]; then exit; fi
  if [ `disk-watcher` = "true" ]; then exit; fi

  # if [[ "$1" == "suspend" ]]; then
  #   systemctl suspend
  # fi
''
