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
    ../../applications/modules/arcmenu.nix
    ../../applications/modules/dash-to-panel.nix
    ./home.nix
    ./startup.nix
  ];

  services.xserver.desktopManager.gnome.enable = cfg.enable; # Install gnome

  programs.dconf.enable = mkIf (cfg.enable) true;

  environment.systemPackages =
    with pkgs;
    (
      if (cfg.enable) then
        [
          gnome-extension-manager # Gnome extensions manager and downloader
          gnome-tweaks # Tweaks missing from pure gnome
          gnomeExtensions.appindicator # Tray icons for gnome
          gnomeExtensions.quick-settings-tweaker
        ]
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
