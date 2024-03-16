{ pkgs, lib, config, ... }:
let
  inherit (lib) attrNames filter foldl';

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);

  vpn-toggle = import modules/vpn-watcher.nix { inherit pkgs; };
  vpn-watcher = import modules/vpn-toggle.nix { inherit pkgs; };
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let username = cfg.system.user.${user}.username;
    in {
      ${username}.home = {
        packages = with pkgs; [ vpn-toggle vpn-watcher psmisc ];

        file = {
          ".config/waybar/config".text = ''
            {
              "layer": "top",
              "modules-left": ["hyprland/window"],
              "modules-center": ["hyprland/workspaces"] ,
              "modules-right": [
                "tray",
                "custom/vpn",
                "custom/separator",
                "bluetooth",
                "custom/separator",
                "hyprland/language",
                "custom/separator",
                "pulseaudio",
                "custom/separator",
                "clock",
                "custom/notification",
                "custom/separator",
                "custom/power",
              ],

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

              "pulseaudio": {
                "format": "{icon}  {volume}",
                "format-muted": "󰝟",
                "format-icons": {
                  "headphone": "󰋋",
                  "headset": "󰋎",
                  "phone": "",
                  "car": "󰄋",
                  "default": ["󰕿", "󰖀", "󰕾"]
                },
                "scroll-step": 5,
                "on-click": "pavucontrol"
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
                "on-click": "hyprctl switchxkblayout kingston-hyperx-alloy-fps-pro-mechanical-gaming-keyboard-1 next"
              },

              "hyprland/window": {
                "format": "{}",
                "separate-outputs": true,
                "max-length": 40
              },

              "custom/power": {
                "format": "",
                "on-click": "wlogout",
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
            }
          '';

          ".config/waybar/style.css".source = ./style.css;
        };
      };
    }) users;
}
