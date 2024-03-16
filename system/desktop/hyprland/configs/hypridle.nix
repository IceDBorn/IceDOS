{ lib, config, ... }:

let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let
      username = cfg.system.user.${user}.username;
      idle = cfg.system.user.${user}.desktop.idle;

      lock = if (idle.lock.enable) then ''
        listener {
            timeout = ${idle.lock.seconds}
            on-timeout = hyprlock-wrapper lock
        }
      '' else
        "";

      disableMonitors = if (idle.disableMonitors.enable) then ''
        listener {
            timeout = ${idle.disableMonitors.seconds}
            on-timeout = hyprlock-wrapper off
            on-resume = hyprctl dispatch dpms on
        }
      '' else
        "";

      suspend = if (idle.suspend.enable) then ''
        listener {
            timeout = ${idle.suspend.seconds}
            on-timeout = hyprlock-wrapper suspend
        }
      '' else
        "";
    in {
      ${username}.home.file.".config/hypr/hypridle.conf".text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = loginctl lock-session
            after_sleep_cmd = hyprctl dispatch dpms on
        }

        # Lower brightness
        listener {
            timeout = ${cfg.desktop.hyprland.lock.secondsToLowerBrightness}
            on-timeout = brightnessctl -s set 10 && brightnessctl -sd rgb:kbd_backlight set 0
            on-resume = brightnessctl -r && brightnessctl -rd rgb:kbd_backlight
        }

        ${lock}

        ${disableMonitors}

        ${suspend}
      '';
    }) users;
}
