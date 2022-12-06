{ pkgs, ... }:

{
	virtualisation = {
		docker.enable = true; # Enable docker
		libvirtd.enable = true; # A daemon that manages virtual machines
		lxd.enable = true; # Container daemon
		spiceUSBRedirection.enable = true; # Passthrough USB devices
		waydroid.enable = true; # Android emulator
	};

	environment.systemPackages = with pkgs; [
		docker # Containers
		distrobox # Wrapper around docker to create and start containers
	];
}
