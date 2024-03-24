{ config, lib, pkgs, ... }:

let
  inherit (lib) attrNames filter foldl' mkIf;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let username = cfg.system.user.${user}.username;
    in {
      ${username} = mkIf (cfg.desktop.hyprland.enable) {
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

          # Add wleave layout
          ".config/wleave/layout" = { source = configs/wleave/layout; };

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
