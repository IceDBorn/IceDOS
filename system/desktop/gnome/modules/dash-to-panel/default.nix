{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) map mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf cfg.desktop.gnome.extensions.dashToPanel {
  environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-panel ];

  home-manager.users = mapAttrs (user: _: {
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ "dash-to-panel@jderose9.github.com" ];
      };

      "org/gnome/shell/extensions/dash-to-panel" = {
        panel-element-positions = ''
          {
            "0": [
              {"element":"showAppsButton","visible":false,"position":"stackedTL"},
              {"element":"activitiesButton","visible":false,"position":"stackedTL"},
              {"element":"leftBox","visible":true,"position":"stackedTL"},
              {"element":"taskbar","visible":true,"position":"stackedTL"},
              {"element":"centerBox","visible":true,"position":"stackedBR"},
              {"element":"rightBox","visible":true,"position":"stackedBR"},
              {"element":"dateMenu","visible":true,"position":"stackedBR"},
              {"element":"systemMenu","visible":true,"position":"stackedBR"},
              {"element":"desktopButton","visible":true,"position":"stackedBR"}
            ],
            "1": [
              {"element":"showAppsButton","visible":false,"position":"stackedTL"},
              {"element":"activitiesButton","visible":false,"position":"stackedTL"},
              {"element":"leftBox","visible":true,"position":"stackedTL"},
              {"element":"taskbar","visible":true,"position":"stackedTL"},
              {"element":"centerBox","visible":true,"position":"stackedBR"},
              {"element":"rightBox","visible":true,"position":"stackedBR"},
              {"element":"dateMenu","visible":true,"position":"stackedBR"},
              {"element":"systemMenu","visible":true,"position":"stackedBR"},
              {"element":"desktopButton","visible":true,"position":"stackedBR"}
            ]
          }
        ''; # Disable activities button
        panel-sizes = ''{"0":44}'';
        appicon-margin = 4;
        dot-style-focused = "DASHES";
        dot-style-unfocused = "DOTS";
        hide-overview-on-startup = true;
        scroll-icon-action = "NOTHING";
        scroll-panel-action = "NOTHING";
        hot-keys = true;
      };
    };
  }) cfg.system.users;
}
