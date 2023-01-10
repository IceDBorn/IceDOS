{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
	home-manager.users.${config.main.user.username}.home.file = lib.mkIf (config.desktop-environment.gnome.enable && config.desktop-environment.gnome.configuration.startup-items.enable) {
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
		".config/autostart/signal-desktop.desktop" = {
			text = ''
				[Desktop Entry]
				Name=Signal
				Exec=signal-desktop
				Icon=signal
				StartupWMClass=signal
			'';
			recursive = true;
		};

		# Add steam to startup
		".config/autostart/steam.desktop" = {
			source = ./steam.desktop;
			recursive = true;
		};
	};
}
