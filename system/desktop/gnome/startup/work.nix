{ config, pkgs, lib, ... }:

lib.mkIf config.work.user.enable {
	home-manager.users.${config.work.user.username}.home.file = lib.mkIf (config.desktop-environment.gnome.enable && config.desktop-environment.gnome.configuration.startup-items.enable) {
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
		".config/autostart/slack.desktop" = {
			text = ''
				[Desktop Entry]
				Exec=slack --enable-features=WaylandWindowDecorations
				Icon=slack
				Name=Slack
				StartupWMClass=slack
				Terminal=false
				Type=Application
			'';
			recursive = true;
		};

		# Add terminator to startup
		".config/autostart/terminator.desktop" = {
			text = ''
				[Desktop Entry]
				Exec=terminator
				Icon=terminator
				Name=Terminator
				StartupWMClass=terminator
				Terminal=false
				Type=Application
			'';
			recursive = true;
		};
	};
}
