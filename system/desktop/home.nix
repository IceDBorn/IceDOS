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
		xdg.desktopEntries.codium = {
			type = "Application";
			exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
			icon = "code";
			terminal = false;
			categories = [ "Utility" "TextEditor" "Development" "IDE" ];
			name = "VSCodium";
			genericName = "Text Editor";
			comment = "Code Editing. Redefined.";
			actions.new-empty-window = {
				"exec" = "codium --new-window %F";
				"icon" = "code";
				"name" = "New Empty Window";
			};
		};

		# Force signal to use wayland
		xdg.desktopEntries.signal-desktop = {
			type = "Application";
			exec = "signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
			icon = "signal-desktop";
			terminal = false;
			categories = [ "Network" "InstantMessaging" "Chat" ];
			name = "Signal";
			genericName = "Text Editor";
			comment = "Private messaging from your desktop";
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
		xdg.desktopEntries.codium = {
			type = "Application";
			exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
			icon = "code";
			terminal = false;
			categories = [ "Utility" "TextEditor" "Development" "IDE" ];
			name = "VSCodium";
			genericName = "Text Editor";
			comment = "Code Editing. Redefined.";
			actions.new-empty-window = {
				"exec" = "codium --new-window %F";
				"icon" = "code";
				"name" = "New Empty Window";
			};
		};

		# Force signal to use wayland
		xdg.desktopEntries.signal-desktop = {
			type = "Application";
			exec = "signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
			icon = "signal-desktop";
			terminal = false;
			categories = [ "Network" "InstantMessaging" "Chat" ];
			name = "Signal";
			genericName = "Text Editor";
			comment = "Private messaging from your desktop";
		};
	};
}
