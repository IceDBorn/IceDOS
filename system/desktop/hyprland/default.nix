{ pkgs, config, lib, ... }:

{
	imports = [
		# Setup home manager for hyprland
		./home.nix
	];

	programs = {
		nm-applet.enable = config.desktop-environment.hyprland.enable; # Network manager tray icon
	};

	environment = lib.mkIf config.desktop-environment.hyprland.enable {
		systemPackages = with pkgs; [
			# Status bar
			(waybar.overrideAttrs (oldAttrs: {
				mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
				postPatch = ''
					sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
				'';
			}))
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
		dbus.enable = config.desktop-environment.hyprland.enable;
		gvfs.enable = config.desktop-environment.hyprland.enable; # Needed for nautilus
	};

	security.polkit.enable = config.desktop-environment.hyprland.enable;
}
