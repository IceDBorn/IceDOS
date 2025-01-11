{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) filterAttrs mapAttrs;
  cfg = config.icedos;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);

  environment.systemPackages = with pkgs; [
    brightnessctl
    jc
    jq
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/nwg-panel/config".text = ''
        [
          {
            "name": "hyprpanel",
            "output": "All",
            "layer": "top",
            "position": "top",
            "height": 26,
            "width": "auto",
            "margin-top": 0,
            "margin-bottom": 0,
            "padding-horizontal": 0,
            "padding-vertical": 0,
            "spacing": 0,
            "controls": "right",
            "items-padding": 0,
            "css-name": "hyprpanel",
            "icons": "light",
            "modules-left": [
              "playerctl"
            ],
            "modules-center": [
              "hyprland-taskbar"
            ],
            "modules-right": [
              "tray",
              ${
                if (cfg.desktop.hyprland.gatewayVpn) then
                  ''
                    "executor-vpn",
                  ''
                else
                  ""
              }
              "executor-keyboard-layout",
              "clock"
            ],
            "controls-settings": {
              "alignment": "right",
              "components": [
                ${
                  if (cfg.hardware.devices.laptop) then
                    ''
                      "battery",
                      "brightness",
                    ''
                  else
                    ""
                }
                "per-app-volume",
                "volume"
              ],
              "commands": {
                "battery": "",
                "net": "",
                "bluetooth": "blueman-manager"
              },
              "custom-items": [],
              "menu": {
                "name": "Power",
                "icon": "system-shutdown-symbolic",
                "items": [
                  {
                    "name": "Lock",
                    "cmd": "loginctl lock-session"
                  },
                  {
                    "name": "Logout",
                    "cmd": "hyprctl dispatch exit"
                  },
                  {
                    "name": "Suspend",
                    "cmd": "systemctl suspend"
                  },
                  {
                    "name": "Restart",
                    "cmd": "systemctl reboot"
                  },
                  {
                    "name": "Shutdown",
                    "cmd": "systemctl -i poweroff"
                  }
                ]
              },
              "show-values": false,
              "interval": 30,
              "icon-size": 14,
              "hover-opens": false,
              "leave-closes": false,
              "click-closes": true,
              "css-name": "controls-window",
              "net-interface": "wlan0",
              "system-shutdown-symbolic": "system-shutdown",
              "output-switcher": true,
              "window-width": 300,
              "window-margin": 0,
              "battery-low-level": 10,
              "root-css-name": "controls-overview",
              "backlight-device": "${cfg.desktop.hyprland.backlight}",
              "backlight-controller": "brightnessctl",
              "show-brightness": false,
              "show-volume": false,
              "show-battery": false,
              "per-app-volume": false,
              "window-margin-horizontal": 0,
              "window-margin-vertical": 0,
              "battery-low-interval": 3,
              "processes-label": "Processes",
              "readme-label": "README",
              "angle": 0.0
            },
            "playerctl": {
              "buttons-position": "left",
              "icon-size": 14,
              "chars": 35,
              "scroll": true,
              "show-cover": false,
              "cover-size": 14,
              "button-css-name": "button-playerctl",
              "label-css-name": "",
              "interval": 1,
              "angle": 0.0
            },
            "clock": {
              "format": "%H:%M:%S",
              "interval": 1,
              "on-right-click": "",
              "tooltip-text": "",
              "on-left-click": "",
              "on-middle-click": "",
              "on-scroll-up": "",
              "on-scroll-down": "",
              "css-name": "clock",
              "root-css-name": "root-clock",
              "tooltip-date-format": false,
              "angle": 0.0,
              "calendar-path": "",
              "calendar-css-name": "calendar-window",
              "calendar-placement": "top-right",
              "calendar-margin-horizontal": 0,
              "calendar-margin-vertical": 0,
              "calendar-icon-size": 14,
              "calendar-interval": 60,
              "calendar-on": true
            },
            "scratchpad": {
              "css-name": "",
              "icon-size": 14,
              "angle": 0.0,
              "single-output": false
            },
            "menu-start": "off",
            "tray": {
              "icon-size": 14,
              "root-css-name": "tray",
              "inner-css-name": "inner-tray",
              "smooth-scrolling-threshold": 0
            },
            "swaync": {
              "tooltip-text": "",
              "on-left-click": "swaync-client -t",
              "on-middle-click": "",
              "on-right-click": "",
              "on-scroll-up": "",
              "on-scroll-down": "",
              "root-css-name": "root-swaync",
              "css-name": "swaync",
              "icon-placement": "left",
              "icon-size": 14,
              "interval": 1,
              "always-show-icon": true
            },
            "exclusive-zone": true,
            "monitor": "",
            "homogeneous": true,
            "sigrt": 64,
            "use-sigrt": false,
            "start-hidden": false,
            "hyprland-taskbar": {
              "name-max-len": 24,
              "icon-size": 14,
              "workspaces-spacing": 0,
              "client-padding": 0,
              "show-app-icon": true,
              "show-app-name": false,
              "show-app-name-special": false,
              "show-layout": false,
              "all-outputs": false,
              "mark-xwayland": false,
              "angle": 0.0,
              "image-size": 14,
              "task-padding": 0
            },
            "hyprland-workspaces": {
              "num-ws": 30,
              "show-icon": false,
              "image-size": 14,
              "show-name": false,
              "name-length": 40,
              "show-empty": false,
              "mark-content": false,
              "show-names": false,
              "mark-floating": false,
              "mark-xwayland": false,
              "angle": 0.0
            },
            "executor-vpn": {
              "script": "vpn-watcher",
              "tooltip-text": "",
              "on-left-click": "vpn-toggle",
              "on-middle-click": "",
              "on-right-click": "",
              "on-scroll-up": "",
              "on-scroll-down": "",
              "root-css-name": "vpn-root",
              "css-name": "vpn",
              "icon-placement": "right",
              "icon-size": 14,
              "interval": 60,
              "angle": 0.0,
              "sigrt": 34,
              "use-sigrt": true
            },
            "executor-keyboard-layout": {
              "script": "keyboard-layout-watcher",
              "tooltip-text": "",
              "on-left-click": "",
              "on-middle-click": "",
              "on-right-click": "",
              "on-scroll-up": "",
              "on-scroll-down": "",
              "root-css-name": "",
              "css-name": "keyboard-layout",
              "icon-placement": "left",
              "icon-size": 14,
              "interval": 0,
              "angle": 0.0,
              "sigrt": 35,
              "use-sigrt": true
            }
          }
        ]
      '';

      ".config/nwg-panel/style.css".text = ''
        * {
          color: #dfdfdf;
          font-family: JetBrainsMono Nerd Font;
          font-size: 14px;
          font-weight: bold;
        }

        #hyprpanel {
          background: #000000;
        }

        *:selected {
          background: #2b2b2b;
          border-radius: 20px;
          box-shadow: 0 0 1px #2b2b2b inset;
        }

        #vpn {
          padding: 0 6px 0 5px;
        }

        #button-playerctl {
          background: #000000;
          padding: 0;
          border-radius: 20px;
        }

        #button-playerctl:hover {
          background: #2b2b2b;
        }

        #task-box-icon {
          padding: 0 3px;
        }

        #task-box-focused {
          background: #474747;
          border-radius: 20px;
        }

        #controls-window,
        #calendar-window {
          background: #242424;
          border-radius: 0;
          border-bottom-left-radius: 10px;
        }

        #controls-window *:selected,
        #calendar-window *:selected {
          background: #515151;
        }
      '';
    };

    systemd.user.services.nwg-panel = {
      Unit.Description = "Nwg Panel - Hyprland panel";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${pkgs.nwg-panel}/bin/nwg-panel";
        Restart = "always";
        Nice = "-20";
      };
    };
  }) cfg.system.users;
}
