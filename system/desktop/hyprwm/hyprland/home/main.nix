{ config, lib, ... }:

lib.mkIf
(config.main.user.enable && config.desktop-environment.hyprland.enable) {
  home-manager.users.${config.main.user.username} = {
    home.file = {
      ".config/hypr/hyprland.conf" = {
        source =
          if (config.desktop-environment.hyprland.dual-monitor.enable) then
            ../../../../applications/configs/hyprland/hyprland-dual.conf
          else
            ../../../../applications/configs/hyprland/hyprland.conf;
        recursive = true;
      }; # Add hyprland config

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

      ".config/hypr/hyprpaper.jpg" = {
        source = ../../../../applications/configs/hyprland/hyprpaper.jpg;
        recursive = true;
      };

      ".config/zsh/vpn-watcher.sh" = {
        source = ../../../../scripts/vpn-watcher.sh;
        recursive = true;
      }; # Add vpn watcher script
    };
  };
}
