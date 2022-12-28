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

			# Add arkenfox user.js
			".mozilla/firefox/privacy/user.js" = {
				source =
				"${(config.nur.repos.slaier.arkenfox-userjs.overrideAttrs (oldAttrs: {
					installPhase = ''
						cat ${../configs/firefox-user-overrides.js} >> user.js
						mkdir -p $out
						cp ./user.js $out/user.js
					'';
				}))}/user.js";
				recursive = true;
			};

			# Set firefox to privacy profile
			".mozilla/firefox/profiles.ini" = {
				source = ../configs/firefox-profiles.ini;
				recursive = true;
			};

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

			# Add adwaita steam skin
			".local/share/Steam/skins/Adwaita" = {
				source = "${(pkgs.callPackage ../programs/self-built/adwaita-for-steam {})}/build/Adwaita";
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

			# Add arkenfox user.js
			".mozilla/firefox/privacy/user.js" = {
				source =
				"${(config.nur.repos.slaier.arkenfox-userjs.overrideAttrs (oldAttrs: {
					installPhase = ''
						cat ${../configs/firefox-user-overrides.js} >> user.js
						mkdir -p $out
						cp ./user.js $out/user.js
					'';
				}))}/user.js";
				recursive = true;
			};

			# Set firefox to privacy profile
			".mozilla/firefox/profiles.ini" = {
				source = ../configs/firefox-profiles.ini;
				recursive = true;
			};

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
}
