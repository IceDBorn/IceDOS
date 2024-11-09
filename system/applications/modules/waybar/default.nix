{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs optionals;
  cfg = config.icedos;
  vpn-toggle = import ./vpn-toggle.nix { inherit config pkgs; };
  vpn-watcher = import ./vpn-watcher.nix { inherit pkgs; };
in
{
  home-manager.users = mapAttrs (user: _: {
    home = {
      packages =
        with pkgs;
        [ waybar ]
        ++ optionals (cfg.desktop.hyprland.gatewayVpn) [
          psmisc
          vpn-toggle
          vpn-watcher
        ];

      file = {
        ".config/waybar/config".text = ''
          {
            "layer": "top",
            "modules-left": ["hyprland/window"],
            "modules-center": ["hyprland/workspaces"] ,
            "modules-right": [
              "tray",
              ${
                if (cfg.desktop.hyprland.gatewayVpn) then
                  ''
                    "custom/vpn",
                  ''
                else
                  ""
              }
              "idle_inhibitor",
              "custom/separator",
              ${
                if (cfg.hardware.bluetooth) then
                  ''
                    "bluetooth",
                    "custom/separator",
                  ''
                else
                  ""
              }
              "hyprland/language",
              "custom/separator",
              "wireplumber",
              "custom/separator",
              "clock",
              "custom/notification",
              ${
                if (cfg.hardware.devices.laptop) then
                  ''
                    "custom/separator",
                    "backlight",
                    "battery",
                  ''
                else
                  ""
              }
              "custom/separator",
              "custom/power",
            ],

            "backlight": {
              "device": "${cfg.desktop.hyprland.backlight}",
              "format": "{icon}",
              "format-icons": ["󰃞", "󰃝", "󰃟", "󰃠"],
              "tooltip-format": "{percent}%",
              "on-scroll-up": "swayosd-client --brightness raise",
              "on-scroll-down": "swayosd-client --brightness lower"
            },

            "battery": {
              "interval": 60,
              "format": "{icon}",
              "format-icons": ["", "", "", "", ""],
              "tooltip-format": "{capacity}% {timeTo}",
            },

            "bluetooth": {
              "format": "<span foreground='red'>󰂲</span>",
              "format-on": "󰂯",
              "format-off": "<span foreground='red'>󰂲</span>",
              "format-disabled": "󰂲",
              "format-connected": "󰂱",
              "format-connected-battery": "󰂱  {device_battery_percentage}",
              "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
              "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
              "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
              "tooltip-format-enumerate-connected-battery": "{device_alias}\t{device_address}\t({device_battery_percentage})",
              "on-click": "overskride"
            },

            "tray": {
              "icon-size": 17,
              "spacing": 10,
              "reverse-direction" : true
            },

            "clock": {
              "interval": 1,
              "format": "{:%H:%M:%S}",
              "tooltip-format": "{:%A, %B %d, %Y}",
              "max-length": 25,
              "on-click": "gnome-clocks",
              "on-click-right": "gnome-calendar"
            },

            "wireplumber": {
              "format": "{icon} {volume}",
              "format-muted": "󰝟",
              "format-icons":  ["󰕿", "󰖀", "󰕾"],
              "on-click": "pavucontrol",
              "on-scroll-up": "swayosd-client --output-volume raise",
              "on-scroll-down": "swayosd-client --output-volume lower"
            },

            "hyprland/workspaces": {
              "format": "{icon}",
              "format-icons": {
                "active": "",
                "default": ""
              },
            },

            "hyprland/language": {
              "format": "{}",
              "format-en": "US",
              "format-gr": "GR",
            },

            "hyprland/window": {
              "format": "{}",
              "separate-outputs": true,
              "max-length": 42
            },

            "custom/power": {
              "format": "",
              "on-click": "wleave",
              "tooltip": false
            },

            "custom/vpn": {
              "format": "{}",
              "exec": "vpn-watcher",
              "on-click": "vpn-toggle",
              "return-type": "{}",
              "tooltip": false,
            },

            "custom/separator": {
              "format": "•",
              "tooltip": false
            },

            "custom/notification": {
              "tooltip": false,
              "format": "{icon}",
              "format-icons": {
                "dnd-notification": "<span foreground='white'><sup></sup></span>",
                "dnd-none": "<span foreground='white'><sup></sup></span>",
                "dnd-inhibited-notification": "<span foreground='white'><sup></sup></span>",
                "dnd-inhibited-none": "<span foreground='white'><sup></sup></span>"
              },
              "return-type": "json",
              "exec-if": "which swaync-client",
              "exec": "swaync-client -swb",
              "escape": true
            },

            "idle_inhibitor": {
              "format": "{icon}",
              "format-icons": {
                "activated": "󰅶",
                "deactivated": "󰾪"
              },
              "tooltip": false
            },
          }
        '';

        ".config/waybar/style.css".source = ./style.css;
      };
    };
  }) cfg.system.users;
}
