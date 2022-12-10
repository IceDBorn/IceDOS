{ config, ... }:

{
	users.users.${config.main.user.username} = {
		createHome = true;
		home = "/home/${config.main.user.username}";
		useDefaultShell = true;
		password = "1"; # Default password used for first login, change later with passwd
		isNormalUser = true;
		description = "${config.main.user.description}";
		extraGroups = [ "networkmanager" "wheel" "kvm" "docker" ];
	};

	home-manager.users.${config.main.user.username}.home.stateVersion = "22.05";
}
