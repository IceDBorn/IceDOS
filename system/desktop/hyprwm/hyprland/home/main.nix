{ config, lib, ... }:

lib.mkIf (config.system.user.main.enable && config.desktop.hyprland.enable) {
  home-manager.users.${config.system.user.main.username} = {
    home.file = {
      # Add hyprland config
      ".config/hypr/hyprland.conf" = {
        text = "${config.desktop.hyprland.config}";
      };

      # Add waybar config files
      ".config/waybar/config" = {
        source = ../../../../applications/configs/waybar/config;
        recursive = true;
      };

      ".config/waybar/style.css" = {
        source = ../../../../applications/configs/waybar/style.css;
        recursive = true;
      };

      # Add wlogout config files
      ".config/wlogout/layout" = {
        source = ../../../../applications/configs/wlogout/layout;
        recursive = true;
      };

      ".config/wlogout/style.css" = {
        source = ../../../../applications/configs/wlogout/style.css;
        recursive = true;
      };

      # Add hyprpaper config files
      ".config/hypr/hyprpaper.conf" = {
        text = ''
          preload = ~/.config/hypr/hyprpaper.jpg
          wallpaper = , ~/.config/hypr/hyprpaper.jpg
          ipc = off
        '';
        recursive = true;
      };

      ".config/hypr/hyprpaper.jpg" = { source = ../configs/hyprpaper.jpg; };

      ".config/zsh/vpn-watcher.sh" = {
        source = ../../../../scripts/vpn-watcher.sh;
        recursive = true;
      }; # Add vpn watcher script
    };
  };
}
