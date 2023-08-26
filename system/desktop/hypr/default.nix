{ pkgs, config, lib, ... }:

{
  imports = [
    ./home-main.nix
    ./home-work.nix
  ]; # Setup home manager for hypr and hyprland

  programs = lib.mkIf (config.desktop-environment.hyprland.enable || config.desktop-environment.hypr.enable) {
    nm-applet.enable = true; # Network manager tray icon
    kdeconnect.enable = true; # Connect phone to PC
  };

  environment = lib.mkIf (config.desktop-environment.hyprland.enable || config.desktop-environment.hypr.enable) {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      blueberry # Bluetooth manager
      gnome-online-accounts # Nextcloud integration
      gnome.file-roller # Archive file manager
      gnome.gnome-calculator # Calculator
      gnome.gnome-control-center # Gnome settings
      gnome.gnome-disk-utility # Disks manager
      gnome.gnome-keyring # Keyring daemon
      gnome.gnome-themes-extra # Adwaita GTK theme
      gnome.nautilus # File manager
      grim # Screenshot tool
      pavucontrol # Sound manager
      polkit_gnome # Polkit manager
      rofi-wayland # App launcher
      swappy # Edit screenshots
      swaynotificationcenter # Notification daemon
    ];

    etc = lib.mkIf (config.desktop-environment.hyprland.enable || config.desktop-environment.hypr.enable) {
      "polkit-gnome".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      "kdeconnectd".source = "${pkgs.libsForQt5.kdeconnect-kde}/libexec/kdeconnectd";
    };
  };

  services = lib.mkIf (config.desktop-environment.hyprland.enable || config.desktop-environment.hypr.enable) {
    dbus.enable = true;
    gvfs.enable = true; # Needed for nautilus
  };

  security.polkit.enable = lib.mkIf (config.desktop-environment.hyprland.enable || config.desktop-environment.hypr.enable) true;

  xdg.portal.extraPortals = lib.mkIf (!config.desktop-environment.gnome.enable) [ pkgs.xdg-desktop-portal-gtk ]; # Needed for steam file picker
}
