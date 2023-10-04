{ config, lib, ... }:

lib.mkIf (config.system.user.main.enable
  && (config.desktop.hypr.enable || config.desktop.hyprland.enable)) {
    home-manager.users.${config.system.user.main.username} = {
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
        ".config/rofi" = {
          source = ../../../applications/configs/rofi;
          recursive = true;
        };

        # Add swaync config file
        ".config/swaync/config.json".source =
          if (config.hardware.monitors.main.enable
            && config.hardware.monitors.secondary.enable) then
            ../../../applications/configs/swaync/config-dual.json
          else
            ../../../applications/configs/swaync/config.json;

        # Add swaync styles file
        ".config/swaync/style.css".source =
          ../../../applications/configs/swaync/style.css;
      };
    };
  }
