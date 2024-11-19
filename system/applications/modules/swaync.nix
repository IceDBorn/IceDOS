{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;

  accentColor =
    if (!cfg.desktop.gnome.enable) then
      cfg.desktop.accentColor
    else
      {
        blue = "#3584e4";
        green = "#3a944a";
        orange = "#ed5b00";
        pink = "#d56199";
        purple = "#9141ac";
        red = "#e62d42";
        slate = "#6f8396";
        teal = "#2190a4";
        yellow = "#c88800";
      }
      .${cfg.desktop.gnome.accentColor};
in
{
  environment.systemPackages = [ pkgs.swaynotificationcenter ];
  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/swaync/style.css".text = ''
        @define-color noti-bg rgb(71, 71, 71);
        @define-color noti-bg-hover rgb(81, 81, 81);

        .notification-row:focus,
        .notification-row:hover {
          background: @noti-bg-hover;
        }

        .notification-row .notification-background .close-button {
          background: rgb(107, 107, 107);
          margin-top: 4px;
          margin-right: 2px;
        }

        .notification-row .notification-background .close-button:hover {
          background: rgb(133, 133, 133);
        }

        .notification-row .notification-background .notification {
          border-radius: 10px;
          border: none;
          background: @noti-bg;
        }

        .notification-row
          .notification-background
          .notification
          .notification-action:hover,
        .notification-row
          .notification-background
          .notification
          .notification-default-action:hover {
          background: @noti-bg-hover;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action {
          border-radius: 10px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content {
          padding: 10px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content
          .image {
          border-radius: 20px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content
          .text-box
          .summary {
          margin-top: 10px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-action:first-child {
          border-bottom-left-radius: 10px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-action:last-child {
          border-bottom-right-radius: 10px;
        }

        .notification-group .notification-group-buttons,
        .notification-group .notification-group-headers {
          margin: 5px;
        }

        .notification-group.collapsed .notification-row .notification {
          background-color: rgba(71, 71, 71, 1.5);
        }

        .notification-group.collapsed:hover
          .notification-row:not(:only-child)
          .notification {
          background-color: rgba(81, 81, 81, 1.5);
        }

        .control-center {
          background: #242424;
          border-radius: 0;
        }

        .control-center .control-center-list .notification {
          box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.5);
        }

        .control-center
          .control-center-list
          .notification
          .notification-default-action:hover,
        .control-center .control-center-list .notification .notification-action:hover {
          background-color: @noti-bg-hover;
        }

        .widget-title {
          margin: 10px;
        }

        .widget-title > button {
          background: @noti-bg;
          border: none;
          border-radius: 20px;
          padding: 10px 20px;
        }

        .widget-title > button:hover {
          background: @noti-bg-hover;
        }

        .widget-dnd {
          margin: 10px;
          font-size: 1.5rem;
        }

        .widget-dnd > switch {
          border-radius: 20px;
          background: #545454;
          border: none;
        }

        .widget-dnd > switch:checked {
          background: ${accentColor};
        }

        .widget-dnd > switch slider {
          background: #ffffff;
          border-radius: 100%;
        }
      '';
    };
  }) cfg.system.users;
}
