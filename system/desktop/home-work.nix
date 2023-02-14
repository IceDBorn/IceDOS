{ config, pkgs, lib, ... }:

lib.mkIf config.work.user.enable {
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
			"org/gnome/nautilus/preferences" = {
				always-use-location-entry = true;
			}; # Nautilus path bar is always editable

			"org/gtk/gtk4/settings/file-chooser" = {
				sort-directories-first = true;
			}; # Nautilus sorts directories first
		};

		# Force mullvad to use wayland and window decorations
		xdg.desktopEntries.mullvad-gui = {
			name = "Mullvad";
			exec = "mullvad-gui --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
			icon = "mullvad-vpn";
		};

		# Force discord to use wayland
		xdg.desktopEntries.discord = {
			name = "Discord";
			exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
			icon = "discord";
		};

		# Force slack to use window decorations
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
