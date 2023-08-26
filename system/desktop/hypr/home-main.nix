{ config, lib, ... }:

lib.mkIf (config.main.user.enable && (config.desktop-environment.hypr.enable || config.desktop-environment.hyprland.enable)) {
  home-manager.users.${config.main.user.username} = {
    home.file = {
      # Add rofi config files
      ".config/rofi/config.rasi" = {
        source = ../../configs/rofi/config.rasi;
        recursive = true;
      };

      ".config/rofi/theme.rasi" = {
        source = ../../configs/rofi/theme.rasi;
        recursive = true;
      };

      ".config/swaync/config.json" = {
        source =
          if (config.desktop-environment.hyprland.dual-monitor.enable) then ../../configs/swaync/config-dual.json
          else ../../configs/swaync/config.json;
        recursive = true;
      }; # Add swaync config file

      ".config/swaync/style.css" = {
        source = ../../configs/swaync/style.css;
        recursive = true;
      }; # Add swaync styles file
    };
  };
}
