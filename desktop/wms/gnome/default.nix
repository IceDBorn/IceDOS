### DESKTOP POWERED BY GNOME ###
{ config, pkgs, ... }:

{
    imports = [
        # Setup home manager for gnome
        ./home.nix
    ];

    # Install gnome
    services.xserver.desktopManager.gnome.enable = true;

    # Gnome packages to install
    environment.systemPackages = with pkgs; [
        gnome.dconf-editor # Edit gnome's dconf
        gnome.gnome-tweaks # Tweaks missing from pure Gnome
        gnomeExtensions.application-volume-mixer # Application volume mixer on the gnome control center
        gnomeExtensions.arcmenu
        gnomeExtensions.bluetooth-quick-connect # Show bluetooth devices on the gnome control center
#        gnomeExtensions.caffeine # Disable auto suspend and screen blank
        gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
        gnomeExtensions.color-picker # Color picker for gnome
        gnomeExtensions.date-menu-formatter
        gnomeExtensions.emoji-selector # Emoji selector
        gnomeExtensions.gamemode # Status indicator for gamemode on gnome
#        gnomeExtensions.gsconnect # KDE Connect implementation for gnome
#        gnomeExtensions.pop-shell # Tiling WM extension
#        gnomeExtensions.smart-auto-move # Remember window state througout reboots and restore it
        gnomeExtensions.sound-output-device-chooser # Sound devices choose on the gnome control center
        gnomeExtensions.tray-icons-reloaded # Tray icons for gnome
        unstable.gnome-extension-manager # Gnome extensions manager and downloader
    ];

    # Gnome packages to exclude
    environment.gnome.excludePackages = with pkgs; [
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
