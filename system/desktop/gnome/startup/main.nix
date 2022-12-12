{ config, pkgs, ... }:

{
	home-manager.users.${config.main.user.username}.home.file = {
		# Add discord-screenaudio to startup
#		".config/autostart/de.shorsh.discord-screenaudio.desktop" = {
#			text = ''
#				[Desktop Entry]
#				Type=Application
#				Name=discord-screenaudio
#				Exec=flatpak run --branch=stable --arch=x86_64 --command=discord-screenaudio de.shorsh.discord-screenaudio
#				Icon=de.shorsh.discord-screenaudio
#				Terminal=false
#				X-Flatpak=de.shorsh.discord-screenaudio
#			'';
#			recursive = true;
#		};

		# Add mullvad vpn to startup
#		".config/autostart/mullvad-vpn.desktop" = {
#			text = ''
#				[Desktop Entry]
#				Name=Mullvad VPN
#				Exec=${pkgs.mullvad-vpn}/bin/mullvad-vpn --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland
#				Terminal=false
#				Type=Application
#				Icon=mullvad-vpn
#				StartupWMClass=Mullvad VPN
#				Comment=Mullvad VPN client
#				Categories=Network;
#			'';
#			recursive = true;
#		};

		# Add nautilus to startup
#		".config/autostart/org.gnome.Nautilus.desktop" = {
#			source = ./nautilus.desktop;
#			recursive = true;
#		};

		# Add signal to startup
		".config/autostart/signal-desktop.desktop" = {
			text = ''
				[Desktop Entry]
				Name=Signal
				Exec=signal-desktop --use-tray-icon --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U
				Icon=signal-desktop
			'';
			recursive = true;
		};

		# Add 2 terminals to startup
#		".config/autostart/startup-terminals.desktop" = {
#			text = ''
#				[Desktop Entry]
#				Categories=System;TerminalEmulator
#				Comment=A fast, cross-platform, OpenGL terminal emulator
#				Exec=bash -c 'kitty & kitty'
#				GenericName=Terminal
#				Icon=Kitty
#				Name=Startup Terminals
#				Terminal=false
#				Type=Application
#				Version=1.4
#			'';
#			recursive = true;
#		};

		# Add steam to startup
		".config/autostart/steam.desktop" = {
			source = ./steam.desktop;
			recursive = true;
		};

		# Add system monitoring center to startup
#		".config/autostart/com.github.hakand34.system-monitoring-center.desktop" = {
#			source = ./system-monitoring-center.desktop;
#			recursive = true;
#		};
	};
}
