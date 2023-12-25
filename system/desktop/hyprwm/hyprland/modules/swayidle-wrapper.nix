{ pkgs, config }:
pkgs.writeShellScriptBin "swayidle-wrapper" ''
  swayidle -w timeout ${config.desktop.hyprland.lock.secondsToLock} 'swaylock-wrapper lock' \
          timeout ${config.desktop.hyprland.lock.secondsToDisableMonitor} 'swaylock-wrapper off'  \
          resume 'swaylock-wrapper on' \
          timeout ${config.desktop.hyprland.lock.secondsToSuspend} 'swaylock-wrapper suspend' \
          before-sleep 'swaylock-wrapper lock' &
''
