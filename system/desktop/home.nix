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

		# Force vscodium to use wayland
#		xdg.desktopEntries.codium = {
#			type = "Application";
#			exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
#			icon = "code";
#			terminal = false;
#			categories = [ "Utility" "TextEditor" "Development" "IDE" ];
#			name = "VSCodium";
#			genericName = "Text Editor";
#			comment = "Code Editing. Redefined.";
#			actions.new-empty-window = {
#				"exec" = "codium --new-window %F";
#				"icon" = "code";
#				"name" = "New Empty Window";
#			};
#		};

		# Force signal to use wayland
		xdg.desktopEntries.signal-desktop = {
			name = "Signal";
			exec = "signal-desktop --use-tray-icon --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
			icon = "signal";
			settings = {
				StartupWMClass = "signal";
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

		# Create apx discord shortcut
		xdg.desktopEntries.discord-screenaudio = {
			type = "Application";
			exec = "apx run --aur discord-screenaudio";
			icon = "discord-screenaudio";
			terminal = false;
			categories = [ "Network" "InstantMessaging" "Chat" ];
			name = "discord-screenaudio";
			genericName = "Discord";
			comment = "Discord with sound on share";
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

		# Force vscodium to use wayland
#		xdg.desktopEntries.codium = {
#			type = "Application";
#			exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
#			icon = "code";
#			terminal = false;
#			categories = [ "Utility" "TextEditor" "Development" "IDE" ];
#			name = "VSCodium";
#			genericName = "Text Editor";
#			comment = "Code Editing. Redefined.";
#			actions.new-empty-window = {
#				"exec" = "codium --new-window %F";
#				"icon" = "code";
#				"name" = "New Empty Window";
#			};
#		};

		# Force signal to use wayland
		xdg.desktopEntries.signal-desktop = {
			name = "Signal";
			exec = "signal-desktop --use-tray-icon --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
			icon = "signal";
			settings = {
				StartupWMClass = "signal";
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
			exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
			icon = "discord";
		};

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.slack = {
			name = "Slack";
			exec = "slack --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
			icon = "slack";
			settings = {
				StartupWMClass = "slack";
			};
		};

		# Create apx discord shortcut
		xdg.desktopEntries.discord-screenaudio = {
			type = "Application";
			exec = "apx run --aur discord-screenaudio";
			icon = "discord-screenaudio";
			terminal = false;
			categories = [ "Network" "InstantMessaging" "Chat" ];
			name = "discord-screenaudio";
			genericName = "Discord";
			comment = "Discord with sound on share";
		};
	};
}
