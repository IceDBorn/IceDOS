{ config, lib, ... }:

lib.mkIf (config.system.user.main.enable && config.desktop.hyprland.enable) {
  home-manager.users.${config.system.user.main.username} = {
    home.file = {
      # Add hyprland config
      ".config/hypr/hyprland.conf".text = "${config.desktop.hyprland.config}";

      # Add waybar config files
      ".config/waybar/config".text = config.desktop.hyprland.waybar.config;
      ".config/waybar/style.css".source = ../configs/waybar/style.css;

      # Add wlogout config files
      ".config/wlogout" = {
        source = ../../../../applications/configs/wlogout;
        recursive = true;
      };

      # Add hyprpaper config files
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/.config/hypr/hyprpaper.jpg
        wallpaper = , ~/.config/hypr/hyprpaper.jpg
        ipc = off
      '';

      ".config/hypr/hyprpaper.jpg".source = ../configs/hyprpaper.jpg;
    };
  };
}
