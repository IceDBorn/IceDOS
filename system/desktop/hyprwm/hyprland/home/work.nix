{ config, lib, ... }:

lib.mkIf (config.system.user.work.enable && config.desktop.hyprland.enable) {
  home-manager.users.${config.system.user.work.username} = {
    home.file = {
      # Add hyprland config
      ".config/hypr/hyprland.conf".text = "${config.desktop.hyprland.config}";

      # Add waybar config files
      ".config/waybar" = {
        source = ../../../../applications/configs/waybar;
        recursive = true;
      };

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

      # Add vpn watcher script
      ".config/zsh/vpn-watcher.sh".source = ../../../../scripts/vpn-watcher.sh;
    };
  };
}
