{
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) filterAttrs;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment = {
    systemPackages = with pkgs; [
      baobab # Disk usage analyser
      file-roller # Archive file manager
      gnome-calculator # Calculator
      gnome-disk-utility # Disks manager
      gnome-keyring # Keyring daemon
      gnome-online-accounts # Nextcloud integration
      gnome-themes-extra # Adwaita GTK theme
      grimblast # Screenshot tool
      hyprland-per-window-layout # Per window layout
      hyprpicker # Color picker
      hyprpolkitagent # Polkit manager
      hyprshade # Shader config tool
      networkmanagerapplet # Network manager app and tray icon
      poweralertd # Battery level alerts
      slurp # Monitor selector
      swappy # Edit screenshots
      wdisplays # Displays manager
    ];
  };

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
    };

    gnome.gnome-keyring.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
