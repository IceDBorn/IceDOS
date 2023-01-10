{ lib, ... }:

{
	imports = [
		# Auto-generated configuration by NixOS
		./hardware-configuration.nix
		./.nix

		# Custom configuration
		./bootloader
		./hardware # Enable various hardware capabilities
		./hardware/amd/radeon.nix
		./hardware/amd/ryzen.nix
		./hardware/intel.nix
		./hardware/laptop.nix
		./hardware/mounts.nix # Disks to mount on startup
		./hardware/nvidia.nix
		./hardware/virtualisation.nix
		./system/desktop
		./system/desktop/gnome
		./system/desktop/hyprland
		./system/programs
		./system/users
	];

	config.system.stateVersion = "22.05"; # Do not change without checking the docs
}
