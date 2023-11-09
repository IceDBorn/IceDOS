{ config, lib, ... }:

lib.mkIf (config.system.user.work.enable
  && (config.desktop.hypr || config.desktop.hyprland.enable)) {
    home-manager.users.${config.system.user.work.username} = {
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
        ".config/swaync/config.json".text = config.applications.swaync.config;

        # Add swaync styles file
        ".config/swaync/style.css".source = ../configs/swaync/style.css;
      };
    };
  }
