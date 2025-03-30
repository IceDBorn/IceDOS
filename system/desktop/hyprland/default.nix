{
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) attrNames filterAttrs;

  getModules =
    path:
    map (dir: ./. + ("/modules/" + dir)) (
      attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
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
      hyprshade # Shader config tool
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
