{ config, pkgs, ... }:

{
	home-manager.users.${config.main.user.username} = {
		gtk = {
			# Change GTK themes
			enable = true;
			theme = {
				name = "Adwaita-dark";
			};
			cursorTheme = {
				name = "Bibata-Modern-Classic";
			};
			iconTheme = {
				name = "Tela-black-dark";
			};
		};

		dconf.settings = {
			# Nautilus path bar is always editable
			"org/gnome/nautilus/preferences" = {
				always-use-location-entry = true;
			};
		};

		# Force mullvad to use wayland
		xdg.desktopEntries.mullvad-gui = {
			name = "Mullvad";
			exec = "mullvad-gui --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
			icon = "mullvad-vpn";
		};

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.discord = {
			name = "Discord";
			exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
			icon = "discord";
		};
	};

	home-manager.users.${config.work.user.username} = {
		gtk = {
			# Change GTK themes
			enable = true;
			theme = {
				name = "Adwaita-dark";
			};
			cursorTheme = {
				name = "Bibata-Modern-Classic";
			};
			iconTheme = {
				name = "Tela-black-dark";
			};
		};

		dconf.settings = {
			# Nautilus path bar is always editable
			"org/gnome/nautilus/preferences" = {
				always-use-location-entry = true;
			};
		};

		# Force mullvad to use wayland
		xdg.desktopEntries.mullvad-gui = {
			name = "Mullvad";
			exec = "mullvad-gui --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
			icon = "mullvad-vpn";
		};

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.discord = {
			name = "Discord";
			exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
			icon = "discord";
		};

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.slack = {
			name = "Slack";
			exec = "slack --enable-features=WaylandWindowDecorations";
			icon = "slack";
			settings = {
				StartupWMClass = "slack";
			};
		};
	};
}
