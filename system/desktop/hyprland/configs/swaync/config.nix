{ config, lib, ... }:
let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);

  workspace = if (config.hardware.monitors.main.enable
    && config.hardware.monitors.secondary.enable) then
    "11"
  else
    "3";
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in {
      ${username}.home.file = {
        ".config/swaync/config.json".text = ''
          {
            "scripts": {
              "messengers": {
                "exec": "hyprctl dispatch workspace ${workspace}",
                "app-name": "((^|, )(WebCord|Signal|pwas))+$",
                "run-on": "action"
              }
            },

            "$schema": "/etc/xdg/swaync/configSchema.json",

            "positionX": "right",
            "positionY": "top",
            "control-center-positionX": "none",
            "control-center-positionY": "top",
            "control-center-margin-top": 0,
            "control-center-margin-bottom": 0,
            "control-center-margin-right": 0,
            "control-center-margin-left": 0,
            "control-center-width": 500,
            "control-center-height": 500,
            "fit-to-screen": true,

            "layer": "overlay",
            "cssPriority": "user",
            "notification-icon-size": 64,
            "notification-body-image-height": 100,
            "notification-body-image-width": 100,
            "timeout": 10,
            "timeout-low": 5,
            "timeout-critical": 0,
            "notification-window-width": 250,
            "keyboard-shortcuts": true,
            "image-visibility": "when-available",
            "transition-time": 200,
            "hide-on-clear": true,
            "hide-on-action": true,
            "script-fail-notify": true,

            "widgets": ["inhibitors", "title", "dnd", "mpris", "notifications"],
            "widget-config": {
              "inhibitors": {
                "text": "Inhibitors",
                "button-text": "Clear All",
                "clear-all-button": true
              },
              "title": {
                "text": "Notifications",
                "clear-all-button": true,
                "button-text": "Clear All"
              },
              "dnd": {
                "text": "Do Not Disturb"
              },
              "label": {
                "max-lines": 5,
                "text": "Label Text"
              },
              "mpris": {
                "image-size": 96,
                "image-radius": 12
              }
            }
          }
        '';

        # Add swaync styles file
        ".config/swaync/style.css".source = ./style.css;
      };
    }) users;
}
