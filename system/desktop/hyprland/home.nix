{ config, lib, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);
  cfg = config.desktop.hyprland;
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in {
      ${username} = lib.mkIf (cfg.enable) {
        # Gnome control center running in Hypr WMs
        xdg.desktopEntries.gnome-control-center = {
          exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
          icon = "gnome-control-center";
          name = "Gnome Control Center";
          terminal = false;
          type = "Application";
        };

        # Set gnome control center to open in the online accounts submenu
        dconf.settings."org/gnome/control-center".last-panel =
          "online-accounts";

        home.file = {
          # Add rofi config files
          ".config/rofi" = {
            source = configs/rofi;
            recursive = true;
          };

          # Add wlogout config files
          ".config/wlogout" = {
            source = configs/wlogout;
            recursive = true;
          };

          # Add hyprpaper config files
          ".config/hypr/hyprpaper.conf".text = ''
            preload = ~/.config/hypr/hyprpaper.jpg
            wallpaper = , ~/.config/hypr/hyprpaper.jpg
            ipc = off
          '';

          ".config/hypr/hyprpaper.jpg".source = configs/hyprpaper.jpg;

          # Add hyprlock configuration
          ".config/hypr/hyprlock.conf".source = configs/hyprlock.conf;
        };
      };
    }) users;
}
