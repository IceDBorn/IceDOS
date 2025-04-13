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
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = [ pkgs.gnome-tweaks ];

  environment.gnome.excludePackages = with pkgs; [
    cheese # Camera
    eog # Image viewer
    epiphany # Web browser
    evince # Document viewer
    geary # Email
    gnome-browser-connector # Install gnome extensions from the browser
    gnome-calendar # Calendar
    gnome-characters # Emojis
    gnome-console # Terminal
    gnome-contacts # Contacts
    gnome-font-viewer # Font viewer
    gnome-maps # Maps
    gnome-music # Music
    gnome-software # Software center
    gnome-system-monitor # System monitoring tool
    gnome-text-editor # Text editor
    gnome-tour # Greeter
    simple-scan # Scanner
    totem # Videos
    yelp # Help
  ];
}
