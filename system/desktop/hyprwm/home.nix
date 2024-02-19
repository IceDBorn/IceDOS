{ config, lib, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in {
      ${username} =
        lib.mkIf (config.desktop.hypr || config.desktop.hyprland.enable) {
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
          };
        };
    }) users;
}
