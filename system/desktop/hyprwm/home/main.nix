{ config, lib, ... }:

lib.mkIf (config.main.user.enable && (config.desktop-environment.hypr.enable
  || config.desktop-environment.hyprland.enable)) {
    home-manager.users.${config.main.user.username} = {
      # Gnome control center running in Hypr WMs
      xdg.desktopEntries.gnome-control-center = {
        exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
        icon = "gnome-control-center";
        name = "Gnome Control Center";
        terminal = false;
        type = "Application";
      };

      # Set gnome control center to open in the online accounts submenu
      dconf.settings."org/gnome/control-center".last-panel = "online-accounts";

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
