{ config, lib, ... }:

lib.mkIf config.main.user.enable {
	users.users.${config.main.user.username} = {
		createHome = config.main.user.enable;
		home = lib.mkIf config.main.user.enable "/home/${config.main.user.username}";
		useDefaultShell = true;
		password = lib.mkIf config.main.user.enable "1"; # Default password used for first login, change later with passwd
		isNormalUser = true;
		description = lib.mkIf config.main.user.enable "${config.main.user.description}";
		extraGroups = lib.mkIf config.main.user.enable [ "networkmanager" "wheel" "kvm" "docker" ];
	};

	home-manager.users.${config.main.user.username}.home.stateVersion = "22.05";
}
