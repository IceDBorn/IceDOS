{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  package = pkgs.walker;
in
mkIf (cfg.applications.walker) {
  environment.systemPackages = with pkgs; [
    package
    wl-clipboard
  ];

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, E, exec, walker -s theme -m emojis"
      "$mainMod, R, exec, walker -s theme -m applications"
      "$mainMod, V, exec, walker -s theme -m clipboard"
    ];

    home.file = {
      ".config/walker/config.json".source = "${package.src}/internal/config/config.default.json";

      ".config/walker/themes/theme.css".text = ''
        #window,
        #box,
        #search,
        #password,
        #input,
        #typeahead,
        #spinner,
        #list,
        child,
        scrollbar,
        slider,
        #item,
        #text,
        #bar,
        #listplaceholder,
        #label,
        #sub,
        #activationlabel {
          all: unset;
        }

        #window {
          color: #ffffff;
        }

        #box {
          background: #242424;
          border-radius: 10px;
          padding: 20px;
        }

        #search {
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 5px;
          padding-right: 5px;
          background: #3a3a3a;
          border-radius: 5px;
          margin-bottom: 20px;
          border: 2px solid #8a78b2;
        }

        #password,
        #input,
        #typeahead {
          padding: 5px;
          border-radius: 10px;
        }

        #input > *:first-child,
        #typeahead > *:first-child {
          margin-right: 10px;
        }

        #typeahead {
          color: #c4c4c4;
        }

        #input placeholder {
          opacity: 0.5;
        }

        #list {
          background: #363636;
          border-radius: 10px;
        }

        child:selected,
        child:hover {
          background: #3c3c3c;
        }

        #item {
          padding: 10px;
          border-bottom: 1px solid #242424;
        }

        #sub {
          font-size: smaller;
          color: #8e8e8e;
        }

        #activationlabel {
          opacity: 0.5;
        }

        .activation #activationlabel {
          opacity: 1;
          color: ${cfg.internals.accentColor};
        }

        .activation #text,
        .activation #icon,
        .activation #search {
          opacity: 0.5;
        }
      '';

      ".config/walker/themes/theme.json".text = ''
        {
          "ui": {
            "anchors": {
              "top": true,
              "bottom": true
            },
            "window": {
              "v_align": "center",
              "box": {
                "width": 400,
                "margins": {
                  "top": 200
                },
                "v_align": "center",
                "h_align": "center",
                "search": {
                  "width": 400,
                  "spacing": 5
                },
                "scroll": {
                  "list": {
                    "width": 400,
                    "marker_color": "${cfg.internals.accentColor}",
                    "max_height": 300,
                    "min_width": 400,
                    "max_width": 400,
                    "item": {
                      "spacing": 10,
                      "activation_label": {
                        "x_align": 1.0,
                        "width": 20
                      },
                      "icon": {
                        "theme": "Theme"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      '';
    };

    systemd.user.services.walker = {
      Unit.Description = "Walker - Application Runner";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/bin/walker --gapplication-service";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
