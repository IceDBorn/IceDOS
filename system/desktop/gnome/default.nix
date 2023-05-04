### DESKTOP POWERED BY GNOME ###
{ pkgs, config, lib, ... }:

{
	imports = [
		# Setup home manager for gnome
		./home-main.nix
		./home-work.nix
		./startup # Startup programs
	];

	services.xserver.desktopManager.gnome.enable = config.desktop-environment.gnome.enable; # Install gnome

	programs.dconf.enable = config.desktop-environment.gnome.enable;

	environment.systemPackages = with pkgs; lib.mkIf config.desktop-environment.gnome.enable [
		gnome.dconf-editor # Edit gnome's dconf
		gnome.gnome-tweaks # Tweaks missing from pure gnome
		gnomeExtensions.appindicator # Tray icons for gnome
		gnomeExtensions.arcmenu # Start menu
		# gnomeExtensions.caffeine # Disable auto suspend and screen blank
		gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
		gnomeExtensions.color-picker # Color picker for gnome
		gnomeExtensions.dash-to-panel # An icon taskbar for gnome
		gnomeExtensions.emoji-selector # Emoji selector
		# gnomeExtensions.gsconnect # KDE Connect implementation for gnome
		gnomeExtensions.quick-settings-tweaker # Quick settings tweaker for the gnome control center
		gnome-extension-manager # Gnome extensions manager and downloader
	];

	environment.gnome.excludePackages = with pkgs; lib.mkIf config.desktop-environment.gnome.enable [
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
