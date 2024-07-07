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
          dconf-editor # Edit gnome's dconf
          gnome-extension-manager # Gnome extensions manager and downloader
          gnome-tweaks # Tweaks missing from pure gnome
          gnomeExtensions.appindicator # Tray icons for gnome
          gnomeExtensions.pano # Next-gen Clipboard manager
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
      cheese # Camera
      eog # Image viewer
      epiphany # Web browser
      evince # Document viewer
      geary # Email
      gnome-console # Terminal
      gnome-font-viewer # Font viewer
      gnome-system-monitor # System monitoring tool
      gnome-text-editor # Text editor
      gnome-tour # Greeter
      gnome.gnome-characters # Emojis
      gnome.gnome-maps # Maps
      gnome.gnome-software # Software center
      simple-scan # Scanner
      yelp # Help
    ];
}
