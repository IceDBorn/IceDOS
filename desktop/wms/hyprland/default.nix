{ pkgs, ... }:

{
	imports = [
		# Setup home manager for hyprland
		./home.nix
	];

	programs = {
		nm-applet.enable = true;
	};

	environment = {
		systemPackages = with pkgs; [
			(callPackage ../../../programs/self-built/waybar.nix {}) # Status bar
			baobab # Disk usage analyser
			blueberry # Bluetooth manager
			clipman # Clipboard manager for wayland
			dunst # Notification daemon
			gnome.file-roller # Archive file manager
			gnome.gnome-calculator # Calculator
			gnome.gnome-disk-utility # Disks manager
			gnome.gnome-themes-extra # Adwaita GTK theme
			gnome.nautilus # File manager
			grim # Screenshot tool
			libsForQt5.kdeconnect-kde # Connect phone to PC
			networkmanagerapplet # Network manager tray icon
			pavucontrol # Sound manager
			polkit_gnome # Polkit manager
			rofi-wayland # App launcher
			slurp # Monitor selector
			wdisplays # Displays manager
			wl-clipboard # Clipboard daemon
			wlogout # Logout screen
		];

		etc = {
			"wlogout-icons".source = "${pkgs.wlogout}/share/wlogout/icons";
			"polkit-gnome".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
		};
	};

	services = {
		dbus.enable = true;
		# Needed for nautilus
		gvfs.enable = true;
	};

	# Enable polkit
	security.polkit.enable = true;
}
