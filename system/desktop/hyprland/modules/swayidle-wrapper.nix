{ pkgs, config }:
let
  secondsToLock = config.desktop.hyprland.lock.secondsToLock;
  secondsToDisableMonitor = config.desktop.hyprland.lock;
  secondsToSuspend = config.desktop.hyprland.lock;
in pkgs.writeShellScriptBin "swayidle-wrapper" ''
  swayidle -w timeout ${secondsToLock} 'swaylock-wrapper lock' \
          timeout ${secondsToDisableMonitor} 'swaylock-wrapper off'  \
          resume 'swaylock-wrapper on' \
          timeout ${secondsToSuspend} 'swaylock-wrapper suspend' \
          before-sleep 'swaylock-wrapper lock' &
''
