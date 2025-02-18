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
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = [ pkgs.gnome-tweaks ];

  environment.gnome.excludePackages = with pkgs; [
    cheese # Camera
    eog # Image viewer
    epiphany # Web browser
    evince # Document viewer
    geary # Email
    gnome-characters # Emojis
    gnome-console # Terminal
    gnome-font-viewer # Font viewer
    gnome-maps # Maps
    gnome-software # Software center
    gnome-system-monitor # System monitoring tool
    gnome-text-editor # Text editor
    gnome-tour # Greeter
    simple-scan # Scanner
    yelp # Help
  ];
}
