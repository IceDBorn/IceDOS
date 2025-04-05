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
  environment.systemPackages = [ pkgs.jq ];
  security.pam.services.hyprlock = { };

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, L, exec, ${pkgs.writeShellScript "lock" ''
        lock="/tmp/icedos/lock"

        if [ -f "$lock" ]; then
          kill -9 "$(cat "$lock")"
          loginctl lock-session
        fi
      ''}"
    ];

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
        };

        background = {
          blur_passes = 5;
          blur_size = 1;
          brightness = 0.6;
          color = "rgba(25, 20, 20, 1.0)";
          contrast = 0.8;
          noise = 0;
          path = "screenshot";
          vibrancy = 0.2;
          vibrancy_darkness = 0.0;
        };

        input-field = {
          capslock_color = "rgb(76,175,80)";
          dots_center = true;
          dots_rounding = -2;
          dots_size = 0.25;
          dots_spacing = 0.15;
          fade_on_empty = false;
          font_color = "rgb(255, 255, 255)";
          halign = "center";
          hide_input = false;
          inner_color = "rgb(52, 52, 52)";
          outer_color = "rgba(0, 0 , 0, 0)";
          outline_thickness = 2;
          placeholder_text = "Enter password...";
          position = "0, 0";
          rounding = -1;
          size = "230, 50";
          valign = "center";
        };

        label = [
          {
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 24;
            halign = "center";
            position = "0, 50";
            text = ''cmd[update:1000] echo "$(date +%H:%M:%S)"'';
            valign = "center";
          }
          {
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 14;
            halign = "center";
            position = "0, -45";
            text = ''cmd[update:500] echo $(hyprctl devices -j | jq -r '.'keyboards' | .[] | select(.main==true) | .'active_keymap''')'';
            valign = "center";
          }
        ];
      };
    };
  }) cfg.system.users;
}
