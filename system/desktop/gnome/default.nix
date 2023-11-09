# ## DESKTOP POWERED BY GNOME ###
{ pkgs, config, lib, ... }:

{
  imports = [
    # Setup home manager for gnome
    ./home/main.nix
    ./home/work.nix
    ./startup # Startup programs
  ];

  services.xserver.desktopManager.gnome.enable =
    config.desktop.gnome.enable; # Install gnome

  programs.dconf.enable = config.desktop.gnome.enable;

  environment.systemPackages = with pkgs;
    (if (config.desktop.gnome.enable) then
      [
        gnome.dconf-editor # Edit gnome's dconf
        gnome.gnome-tweaks # Tweaks missing from pure gnome
        gnomeExtensions.appindicator # Tray icons for gnome
        gnomeExtensions.pano # Next-gen Clipboard manager
        gnome-extension-manager # Gnome extensions manager and downloader
        gnomeExtensions.quick-settings-tweaker
      ] ++ lib.optional config.desktop.gnome.arcmenu
      gnomeExtensions.arcmenu # Start menu
      ++ lib.optional config.desktop.gnome.caffeine
      gnomeExtensions.caffeine # Disable auto suspend and screen blank
      ++ lib.optional config.desktop.gnome.dashToPanel
      gnomeExtensions.dash-to-panel # An icon taskbar for gnome
      ++ lib.optional config.desktop.gnome.gsconnect
      gnomeExtensions.gsconnect # KDE Connect implementation for gnome
    else
      [ ]);

  environment.gnome.excludePackages = with pkgs;
    lib.mkIf config.desktop.gnome.enable [
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
