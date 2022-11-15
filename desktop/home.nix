{ config, pkgs, home-manager, ... }:

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

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.discord = {
			name = "Discord";
			exec = "discord --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
			icon = "discord";
		};

		# Force webcord to use wayland
		xdg.desktopEntries.webcord = {
			name = "Webcord";
			exec = "io.github.spacingbat3.webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
			icon = "webcord";
		};

		home.file = {
			# Add zsh theme to zsh directory
			".config/zsh/zsh-theme.zsh" = {
				source = ../configs/zsh-theme.zsh;
				recursive = true;
			};

			# Add protondown script to zsh directory
			".config/zsh/protondown.sh" = {
				source = ../scripts/protondown.sh;
				recursive = true;
			};

			# Add firefox privacy profile overrides
#			".mozilla/firefox/privacy/user-overrides.js" = {
#				source = ../configs/firefox-user-overrides.js;
#				recursive = true;
#			};

			# Set firefox to privacy profile
#			".mozilla/firefox/profiles.ini" = {
#				source = ../configs/firefox-profiles.ini;
#				recursive = true;
#			};

			# Add noise suppression microphone
			".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
				source = ../configs/pipewire.conf;
				recursive = true;
			};

			# Add btop config
			".config/btop/btop.conf" = {
				source = ../configs/btop.conf;
				recursive = true;
			};

			# Add kitty session config
			".config/kitty/kitty.session" = {
				source = ../configs/kitty.session;
				recursive = true;
			};
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

		# Force discord to use wayland and disable gpu to allow it to work
		xdg.desktopEntries.discord = {
			name = "Discord";
			exec = "discord --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland";
			icon = "discord";
		};

		# Force webcord to use wayland
		xdg.desktopEntries.webcord = {
			name = "Webcord";
			exec = "io.github.spacingbat3.webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
			icon = "webcord";
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

		home.file = {
			# Add zsh theme to zsh directory
			".config/zsh/zsh-theme.zsh" = {
				source = ../configs/zsh-theme.zsh;
				recursive = true;
			};

			# Add protondown script to zsh directory
			".config/zsh/protondown.sh" = {
				source = ../scripts/protondown.sh;
				recursive = true;
			};

			# Add firefox privacy profile overrides
#			".mozilla/firefox/privacy/user-overrides.js" = {
#				source = ../configs/firefox-user-overrides.js;
#				recursive = true;
#			};

			# Set firefox to privacy profile
#			".mozilla/firefox/profiles.ini" = {
#				source = ../configs/firefox-profiles.ini;
#				recursive = true;
#			};

			# Add noise suppression microphone
			".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
				source = ../configs/pipewire.conf;
				recursive = true;
			};

			# Add btop config
			".config/btop/btop.conf" = {
				source = ../configs/btop.conf;
				recursive = true;
			};

			# Add kitty session config
			".config/kitty/kitty.session" = {
				source = ../configs/kitty.session;
				recursive = true;
			};

			# Add terminator
			".config/terminator/config" = {
				source = ../configs/terminator;
				recursive = true;
			};
		};
	};
}
