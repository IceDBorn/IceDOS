{ config, lib, ... }:

lib.mkIf config.work.user.enable {
	users.users.${config.work.user.username} = {
		createHome = true;
		home = "/home/${config.work.user.username}";
		useDefaultShell = true;
		password = "1"; # Default password used for first login, change later with passwd
		isNormalUser = true;
		description = "${config.work.user.description}";
		extraGroups = [ "networkmanager" "wheel" "kvm" "docker" "input" ];
	};

	home-manager.users.${config.work.user.username}.home = {
		stateVersion = config.state-version;
		file.".nix-successful-build" = {
			text = "true";
			recursive = true;
		};
	};
}
