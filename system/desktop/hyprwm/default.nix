{ pkgs, config, lib, ... }:

{
  imports = [
    ./home/main.nix
    ./home/work.nix
    ./configs/swaync/config.nix
  ]; # Setup home manager for hypr and hyprland

  programs =
    lib.mkIf (config.desktop.hyprland.enable || config.desktop.hypr) {
      nm-applet.enable = true; # Network manager tray icon
      kdeconnect.enable = true; # Connect phone to PC
    };

  environment =
    lib.mkIf (config.desktop.hyprland.enable || config.desktop.hypr) {
      systemPackages = with pkgs; [
        baobab # Disk usage analyser
        blueberry # Bluetooth manager
        feh # Minimal image viewer
        gnome-online-accounts # Nextcloud integration
        gnome.file-roller # Archive file manager
        gnome.gnome-calculator # Calculator
        gnome.gnome-clocks # Clock
        gnome.gnome-control-center # Gnome settings
        gnome.gnome-disk-utility # Disks manager
        gnome.gnome-keyring # Keyring daemon
        gnome.gnome-themes-extra # Adwaita GTK theme
        gnome.nautilus # File manager
        grim # Screenshot tool
        networkmanagerapplet # Network manager tray icon
        polkit_gnome # Polkit manager
        rofi-wayland # App launcher
        swappy # Edit screenshots
        swaynotificationcenter # Notification daemon
      ];

      etc = lib.mkIf
        (config.desktop.hyprland.enable || config.desktop.hypr) {
          "polkit-gnome".source =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          "kdeconnectd".source =
            "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
        };
    };

  services =
    lib.mkIf (config.desktop.hyprland.enable || config.desktop.hypr) {
      dbus.enable = true;
      gvfs.enable = true; # Needed for nautilus
      gnome.gnome-keyring.enable = true;
    };

  security = {
    polkit.enable =
      lib.mkIf (config.desktop.hyprland.enable || config.desktop.hypr)
      true;
    pam.services.login.enableGnomeKeyring = true;
  };

  xdg.portal.extraPortals = lib.mkIf (!config.desktop.gnome.enable)
    [ pkgs.xdg-desktop-portal-gtk ]; # Needed for steam file picker
}
