{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
	home-manager.users.${config.main.user.username}.home.file = lib.mkIf (config.desktop-environment.gnome.enable && config.desktop-environment.gnome.configuration.startup-items.enable) {
		# Add discord-screenaudio to startup
		".config/autostart/discord-screenaudio.desktop" = {
			text = ''
				[Desktop Entry]
				Exec=apx --aur run discord-screenaudio
				Icon=discord-screenaudio
				Name=discord-screenaudio
				StartupWMClass=discord-screenaudio
				Terminal=false
				Type=Application
			'';
			recursive = true;
		};

		# Add signal to startup
		".config/autostart/signal-desktop.desktop" = {
			text = ''
				[Desktop Entry]
				Exec=signal-desktop
				Icon=signal
				Name=Signal
				StartupWMClass=signal
				Terminal=false
				Type=Application
			'';
			recursive = true;
		};

		# Add steam to startup
		".config/autostart/steam.desktop" = {
			text = ''
				[Desktop Entry]
				Exec=steam
				Icon=steam
				Name=Steam
				StartupWMClass=steam
				Terminal=false
				Type=Application
			'';
			recursive = true;
		};
	};
}
