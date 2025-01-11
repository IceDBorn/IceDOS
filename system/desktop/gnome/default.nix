{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) filterAttrs mkIf;

  cfg = config.icedos.desktop.gnome;

  getModules =
    path:
    builtins.map (dir: ./. + ("/modules/" + dir)) (
      builtins.attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir path))
    );
in
{
  imports = getModules (./modules);
  services.xserver.desktopManager.gnome.enable = cfg.enable;
  programs.dconf.enable = cfg.enable;

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.enable) [
      gnome-extension-manager # Gnome extensions manager and downloader
      gnome-tweaks # Tweaks missing from pure gnome
      gnomeExtensions.appindicator # Tray icons for gnome
      gnomeExtensions.quick-settings-tweaker
    ];

  environment.gnome.excludePackages =
    with pkgs;
    mkIf (cfg.enable) [
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
