{ config, pkgs, home-manager, ... }:

{
	home-manager.users.${config.main.user.username} = {
		home.file = {
			# Add hyprland config
			".config/hypr/hyprland.conf" = {
				source = ../../../configs/hyprland.conf;
				recursive = true;
			};

			# Add waybar config files
			".config/waybar/config" = {
				source = ../../../configs/waybar/config;
				recursive = true;
			};

			".config/waybar/style.css" = {
				source = ../../../configs/waybar/style.css;
				recursive = true;
			};

			# Add rofi config files
			".config/rofi/config.rasi" = {
				source = ../../../configs/rofi/config.rasi;
				recursive = true;
			};

			".config/rofi/theme.rasi" = {
				source = ../../../configs/rofi/theme.rasi;
				recursive = true;
			};

			# Add dunst config file
			".config/dunst/dunstrc" = {
				source = ../../../configs/dunstrc;
				recursive = true;
			};

			# Add wlogout config files
			".config/wlogout/layout" = {
				source = ../../../configs/wlogout/layout;
				recursive = true;
			};

			".config/wlogout/style.css" = {
				source = ../../../configs/wlogout/style.css;
				recursive = true;
			};

			# Avoid file not found errors for bash
			".bashrc" = {
				text = '''';
				recursive = true;
			};
		};
	};

	home-manager.users.${config.work.user.username} = {
		home.file = {
			# Add hyprland config
			".config/hypr/hyprland.conf" = {
				source = ../../../configs/hyprland.conf;
				recursive = true;
			};

			# Add waybar config files
			".config/waybar/config" = {
				source = ../../../configs/waybar/config;
				recursive = true;
			};

			".config/waybar/style.css" = {
				source = ../../../configs/waybar/style.css;
				recursive = true;
			};

			# Add rofi config files
			".config/rofi/config.rasi" = {
				source = ../../../configs/rofi/config.rasi;
				recursive = true;
			};

			".config/rofi/theme.rasi" = {
				source = ../../../configs/rofi/theme.rasi;
				recursive = true;
			};

			# Add dunst config file
			".config/dunst/dunstrc" = {
				source = ../../../configs/dunstrc;
				recursive = true;
			};

			# Add wlogout config files
			".config/wlogout/layout" = {
				source = ../../../configs/wlogout/layout;
				recursive = true;
			};

			".config/wlogout/style.css" = {
				source = ../../../configs/wlogout/style.css;
				recursive = true;
			};

			# Avoid file not found errors for bash
			".bashrc" = {
				text = '''';
				recursive = true;
			};
		};
	};
}
