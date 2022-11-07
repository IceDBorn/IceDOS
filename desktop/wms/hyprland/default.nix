{ config, pkgs, ... }:
let
	flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
	hyprland = (import flake-compat {
		src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
	}).defaultNix;

	dbus-hypr-environment = pkgs.writeTextFile {
		name = "dbus-hypr-environment";
		destination = "/bin/dbus-hypr-environment";
		executable = true;

		text = ''
			dbus-update-activation-environment --systemd XDG_SESSION_TYPE=wayland WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
			systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
			systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
			systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
		'';
	};
in
{
	imports = [
		# Setup home manager for hyprland
		./home.nix
		# Needed for hyprland
		hyprland.nixosModules.default
	];

	programs = {
		nm-applet.enable = true;
		hyprland = {
			enable = true;
			package = hyprland.packages.${pkgs.system}.default;
		};
	};

	nixpkgs.overlays = [
		(self: super: {
			waybar = super.waybar.overrideAttrs (oldAttrs: {
				mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
			});
		})
	];

	environment = {
		systemPackages = with pkgs; [
			(callPackage ../../../programs/self-built/waybar.nix {}) # Status bar
			baobab # Disk usage analyser
			blueberry # Bluetooth manager
			clipman # Clipboard manager for wayland
			dbus-hypr-environment # Run specific commands
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

	#Enable polkit
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
}
