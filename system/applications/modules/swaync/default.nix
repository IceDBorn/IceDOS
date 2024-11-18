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
  environment.systemPackages = [ pkgs.swaynotificationcenter ];
  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/swaync/cfg.json".text = ''
        {
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

          "widgets": ["inhibitors", "title", "dnd", "notifications"],
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
            }
          }
        }
      '';

      ".config/swaync/style.css".source = ./style.css;
    };
  }) cfg.system.users;
}
