{ config, lib, ... }:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    xdg.desktopEntries.gnome-control-center = {
      exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
      icon = "gnome-control-center";
      name = "Gnome Control Center";
      terminal = false;
      type = "Application";
    };

    dconf.settings."org/gnome/control-center".last-panel = "online-accounts";

    home.file = {
      ".config/rofi" = {
        source = configs/rofi;
        recursive = true;
      };

      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/.config/hypr/hyprpaper.jpg
        wallpaper = , ~/.config/hypr/hyprpaper.jpg
        ipc = off
      '';

      ".config/hypr/hyprpaper.jpg".source = configs/hyprpaper.jpg;
      ".config/hypr/hyprlock.conf".source = configs/hyprlock.conf;
      ".config/hypr/vibrance.glsl".source = configs/vibrance.glsl;
    };
  }) cfg.system.users;
}
