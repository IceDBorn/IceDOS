{ config, lib, ... }:

{
	users.users.${config.work.user.username} = {
		createHome = true;
		home = "/home/${config.work.user.username}";
		useDefaultShell = true;
		password = "1"; # Default password used for first login, change later with passwd
		isNormalUser = true;
		description = lib.mkIf config.work.user.enable "${config.work.user.description}";
		extraGroups = lib.mkIf config.work.user.enable [ "networkmanager" "wheel" "kvm" "docker" ];
	};

	home-manager.users.${config.work.user.username}.home.stateVersion = "22.05";
}
