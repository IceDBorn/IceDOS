{ pkgs, config, lib, ... }:

{
	virtualisation = {
		docker.enable = config.virtualisation-settings.docker.enable;
		libvirtd.enable = config.virtualisation-settings.libvirtd.enable;
		lxd.enable = config.virtualisation-settings.lxd.enable;
		spiceUSBRedirection.enable = config.virtualisation-settings.spiceUSBRedirection.enable;
		waydroid.enable = config.virtualisation-settings.waydroid.enable;
	};

	environment.systemPackages = with pkgs; lib.mkIf config.virtualisation-settings.docker.enable [
		docker # Containers
		distrobox # Wrapper around docker to create and start linux containers
	];
}
