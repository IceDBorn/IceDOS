{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs optional;
  cfg = config.icedos;
in
{
  environment.systemPackages = [ pkgs.brightnessctl ];

  home-manager.users = mapAttrs (
    user: _:
    let
      idle = cfg.system.users.${user}.desktop.idle;
    in
    {
      services.hypridle = {
        enable = true;

        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = ''hyprctl dispatch dpms on'';
          };

          listener =
            [
              {
                timeout = toString (cfg.desktop.hyprland.settings.secondsToLowerBrightness);
                on-timeout = "brightnessctl -s set 10 && brightnessctl -sd rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -r && brightnessctl -rd rgb:kbd_backlight";
              }
            ]
            ++ optional (idle.lock.enable) {
              timeout = toString (idle.lock.seconds);
              on-timeout = "loginctl lock-session";
            }
            ++ optional (idle.disableMonitors.enable) {
              timeout = toString (idle.disableMonitors.seconds);
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            ++ optional (idle.suspend.enable) {
              timeout = toString (idle.suspend.seconds);
              on-timeout = "systemctl suspend";
            };
        };
      };
    }
  ) cfg.system.users;
}
