### DESKTOP POWERED BY GNOME ###
{ pkgs, config, ... }:

{
	imports = [
		./home-main.nix
		./home-work.nix
	]; # Setup home manager

	# Set your time zone
	time.timeZone = "Europe/Bucharest";

	# Set your locale settings
	i18n = {
		defaultLocale = "en_US.utf8";
		extraLocaleSettings.LC_MEASUREMENT = "es_ES.utf8";
	};

	services = {
		xserver = {
			enable = true; # Enable the X11 windowing system

			displayManager = {
				gdm = {
					enable = true;
					autoSuspend = config.desktop-environment.gdm.auto-suspend.enable;
				};

				autoLogin.enable = config.boot.autologin.enable;
  				autoLogin.user = config.main.user.username;
			};

			layout = "us,gr";
		};

		# Enable sound with pipewire
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};

	# Workaround for GDM autologin
	systemd.services = {
		"getty@tty1".enable = false;
		"autovt@tty1".enable = false;
	};

	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true; # Enable service which hands out realtime scheduling priority to user processes on demand, required by pipewire

	networking = {
		networkmanager.enable = true;
		firewall.enable = false;
	};

	security.sudo.extraConfig = "Defaults pwfeedback"; # Show asterisks when typing sudo password

	environment = {
		sessionVariables = {
			QT_QPA_PLATFORMTHEME= "gnome"; # Use gtk theme for qt apps
		};

		# Packages to install for all window manager/desktop environments
		systemPackages = with pkgs; [
			bibata-cursors # Material cursors
			fragments # Bittorrent client following Gnome UI standards
			gnome.adwaita-icon-theme # GTK theme
			gnome.gnome-boxes # VM manager
			gthumb # Image viewer
			pitivi # Video editor
			qgnomeplatform # Use GTK theme for QT apps
			tela-icon-theme # Icon theme
		];
	};

	fonts.fonts = with pkgs; [ meslo-lgs-nf cantarell-fonts jetbrains-mono font-awesome ];
}
