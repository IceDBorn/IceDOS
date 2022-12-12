### DESKTOP POWERED BY GNOME ###
{ pkgs, ... }:

{
	imports = [
		./home.nix # Setup home manager for gnome
		./startup # Startup programs
	];

	services.xserver.desktopManager.gnome.enable = true; # Install gnome

	programs.dconf.enable = true;

	environment.systemPackages = with pkgs; [
		gnome.dconf-editor # Edit gnome's dconf
		gnome.gnome-tweaks # Tweaks missing from pure Gnome
		gnomeExtensions.appindicator # Tray icons for gnome
		gnomeExtensions.bluetooth-quick-connect # Show bluetooth devices on the gnome control center
		gnomeExtensions.caffeine # Disable auto suspend and screen blank
		gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
		gnomeExtensions.color-picker # Color picker for gnome
		gnomeExtensions.emoji-selector # Emoji selector
		gnomeExtensions.gamemode # Status indicator for gamemode on gnome
		gnomeExtensions.gsconnect # KDE Connect implementation for gnome
		gnomeExtensions.pop-shell # Tiling WM extension
		gnomeExtensions.quick-settings-tweaker # Quick settings tweaker for the gnome control center~
		gnomeExtensions.smart-auto-move # Remember window state througout reboots and restore it
		gnome-extension-manager # Gnome extensions manager and downloader
	];

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
