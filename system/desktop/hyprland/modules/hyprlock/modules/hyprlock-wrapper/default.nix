{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
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

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = [ "$mainMod, L, exec, hyprlock-wrapper lock force" ];
  }) cfg.system.users;
}
