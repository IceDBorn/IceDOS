{ config, lib, ... }:

lib.mkIf config.work.user.enable {
	home-manager.users.${config.work.user.username} = lib.mkIf config.desktop-environment.hyprland.enable {
		home.file = {
			".config/hypr/hyprland.conf" = {
				source = ../../configs/hyprland.conf;
				recursive = true;
			}; # Add hyprland config

			# Add waybar config files
			".config/waybar/config" = {
				source = ../../configs/waybar/config;
				recursive = true;
			};

			".config/waybar/style.css" = {
				source = ../../configs/waybar/style.css;
				recursive = true;
			};

			# Add rofi config files
			".config/rofi/config.rasi" = {
				source = ../../configs/rofi/config.rasi;
				recursive = true;
			};

			".config/rofi/theme.rasi" = {
				source = ../../configs/rofi/theme.rasi;
				recursive = true;
			};

			".config/swaync" = {
				source = ../../configs/swaync;
				recursive = true;
			}; # Add swaync config file

			# Add wlogout config files
			".config/wlogout/layout" = {
				source = ../../configs/wlogout/layout;
				recursive = true;
			};

			".config/wlogout/style.css" = {
				source = ../../configs/wlogout/style.css;
				recursive = true;
			};

			".bashrc" = {
				text = '''';
				recursive = true;
			}; # Avoid file not found errors for bash

			# Add hyprpaper config files
			".config/hypr/hyprpaper.conf" = {
				text = ''
					preload = ~/.config/hypr/hyprpaper.jpg
					wallpaper = , ~/.config/hypr/hyprpaper.jpg
					ipc = off
				'';
				recursive = true;
			};

			".config/hypr/hyprpaper.jpg" = {
				source = ../../configs/hyprpaper.jpg;
				recursive = true;
			};

			".config/zsh/vpn-watcher.sh" = {
				source = ../../scripts/vpn-watcher.sh;
				recursive = true;
			}; # Add vpn watcher script
		};
	};
}
