{ config, pkgs, lib, ... }:

lib.mkIf config.work.user.enable {
	home-manager.users.${config.work.user.username}.home.file = lib.mkIf (config.work.user.enable && config.desktop-environment.gnome.enable) {
		# Add discord-screenaudio to startup
		".config/autostart/discord-screenaudio.desktop" = {
			text = ''
				[Desktop Entry]
				Name=discord-screenaudio
				GenericName=Discord
				Exec=apx run discord-screenaudio
				Icon=discord-screenaudio
				StartupWMClass=discord-screenaudio
			'';
			recursive = true;
		};

		# Add signal to startup
		".config/autostart/slack.desktop" = {
			text = ''
				[Desktop Entry]
				Name=Slack
				Exec=slack --enable-features=WaylandWindowDecorations
				Icon=slack
				StartupWMClass=slack
			'';
			recursive = true;
		};

		# Add terminator to startup
		".config/autostart/terminator.desktop" = {
			text = ''
				[Desktop Entry]
				Name=Terminator
				Exec=terminator
				Icon=terminator
			'';
			recursive = true;
		};
	};
}
