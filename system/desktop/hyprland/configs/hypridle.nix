{ lib, config, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);

in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let
      username = config.system.user.${user}.username;
      cfg = config.system.user.${user}.desktop.idle;

      lock = if (cfg.lock.enable) then ''
        listener {
            timeout = ${cfg.lock.seconds}
            on-timeout = hyprlock-wrapper lock
        }
      '' else
        "";

      disableMonitors = if (cfg.disableMonitors.enable) then ''
        listener {
            timeout = ${cfg.disableMonitors.seconds}
            on-timeout = hyprlock-wrapper off
            on-resume = hyprctl dispatch dpms on
        }
      '' else
        "";

      suspend = if (cfg.suspend.enable) then ''
        listener {
            timeout = ${cfg.suspend.seconds}
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
            timeout = ${config.desktop.hyprland.lock.secondsToLowerBrightness}
            on-timeout = brightnessctl -s set 10 && brightnessctl -sd rgb:kbd_backlight set 0
            on-resume = brightnessctl -r && brightnessctl -rd rgb:kbd_backlight
        }

        ${lock}

        ${disableMonitors}

        ${suspend}
      '';
    }) users;
}
