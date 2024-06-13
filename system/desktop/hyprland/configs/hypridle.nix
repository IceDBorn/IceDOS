{ lib, config, ... }:

let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos;
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
  monitor = cfg.hardware.monitors.main.name;
in
{
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        idle = cfg.system.users.${user}.desktop.idle;
        username = cfg.system.users.${user}.username;
      in
      {
        ${username}.home.file.".config/hypr/hypridle.conf".text = ''
          general {
              lock_cmd = pidof hyprlock || hyprlock
              before_sleep_cmd = loginctl lock-session
              after_sleep_cmd = hyprctl dispatch dpms on && xrandr --output "${monitor}" --primary
          }

          # Lower brightness
          listener {
              timeout = ${builtins.toString (cfg.desktop.hyprland.lock.secondsToLowerBrightness)}
              on-timeout = brightnessctl -s set 10 && brightnessctl -sd rgb:kbd_backlight set 0
              on-resume = brightnessctl -r && brightnessctl -rd rgb:kbd_backlight
          }

          ${
            if (idle.lock.enable) then
              ''
                listener {
                    timeout = ${builtins.toString (idle.lock.seconds)}
                    on-timeout = hyprlock-wrapper lock
                }
              ''
            else
              ""
          }

          ${
            if (idle.disableMonitors.enable) then
              ''
                listener {
                    timeout = ${builtins.toString (idle.disableMonitors.seconds)}
                    on-timeout = hyprlock-wrapper off
                    on-resume = hyprctl dispatch dpms on
                }
              ''
            else
              ""
          }

          ${
            if (idle.suspend.enable) then
              ''
                listener {
                    timeout = ${builtins.toString (idle.suspend.seconds)}
                    on-timeout = hyprlock-wrapper suspend
                }
              ''
            else
              ""
          }
        '';
      }
    ) users;
}
