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

	xdg.portal = {
		enable = true;
		extraPortals = [
			pkgs.xdg-desktop-portal
			pkgs.xdg-desktop-portal-wlr
		];
		wlr = {
			enable = true;
			settings.screencast = {
				chooser_type = "simple";
				chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
			};
		};
	};

	# Patch wlr xdg portal to support hyprland
	nixpkgs.overlays = [
		(final: prev: {
			xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (o: {
			patches = (o.patches or [ ]) ++ [
				../../../programs/self-built/xdg-desktop-portal-wlr.patch
			];
			});
		})
	];
}
