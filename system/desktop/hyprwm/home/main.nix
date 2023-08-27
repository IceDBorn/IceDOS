{ config, lib, ... }:

lib.mkIf (config.main.user.enable && (config.desktop-environment.hypr.enable
  || config.desktop-environment.hyprland.enable)) {
    home-manager.users.${config.main.user.username} = {
      home.file = {
        # Add rofi config files
        ".config/rofi/config.rasi" = {
          source = ../../../applications/configs/rofi/config.rasi;
          recursive = true;
        };

        ".config/rofi/theme.rasi" = {
          source = ../../../applications/configs/rofi/theme.rasi;
          recursive = true;
        };

        ".config/swaync/config.json" = {
          source =
            if (config.desktop-environment.hyprland.dual-monitor.enable) then
              ../../../applications/configs/swaync/config-dual.json
            else
              ../../../applications/configs/swaync/config.json;
          recursive = true;
        }; # Add swaync config file

        ".config/swaync/style.css" = {
          source = ../../../applications/configs/swaync/style.css;
          recursive = true;
        }; # Add swaync styles file
      };
    };
  }
