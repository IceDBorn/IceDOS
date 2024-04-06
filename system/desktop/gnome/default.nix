{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf optional;

  cfg = config.icedos.desktop.gnome;
in
{
  imports = [
    # Setup home manager for gnome
    ./home.nix
    # Startup programs
    ./startup.nix
  ];

  services.xserver.desktopManager.gnome.enable = cfg.enable; # Install gnome

  programs.dconf.enable = mkIf (cfg.enable) true;

  environment.systemPackages =
    with pkgs;
    (
      if (cfg.enable) then
        [
          gnome.dconf-editor # Edit gnome's dconf
          gnome.gnome-tweaks # Tweaks missing from pure gnome
          gnomeExtensions.appindicator # Tray icons for gnome
          gnomeExtensions.pano # Next-gen Clipboard manager
          gnome-extension-manager # Gnome extensions manager and downloader
          gnomeExtensions.quick-settings-tweaker
        ]
        ++ optional (cfg.extensions.arcmenu) gnomeExtensions.arcmenu # Start menu
        ++ optional (cfg.extensions.dashToPanel) gnomeExtensions.dash-to-panel # An icon taskbar for gnome
        ++ optional (cfg.extensions.gsconnect) gnomeExtensions.gsconnect # KDE Connect implementation for gnome
      else
        [ ]
    );

  environment.gnome.excludePackages =
    with pkgs;
    mkIf (cfg.enable) [
      epiphany # Web browser
      evince # Document viewer
      gnome-console # Terminal
      gnome-text-editor # Text editor
      gnome-tour # Greeter
      gnome.cheese # Camera
      gnome.eog # Image viewer
      gnome.geary # Email
      gnome.gnome-characters # Emojis
      gnome.gnome-font-viewer # Font viewer
      gnome.gnome-maps # Maps
      gnome.gnome-software # Software center
      gnome.gnome-system-monitor # System monitoring tool
      gnome.simple-scan # Scanner
      gnome.yelp # Help
    ];
}
