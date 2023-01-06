{ lib, ... }:

{
	# Create options for declaring users
	options = {
		main.user = {
			username = lib.mkOption {
				type = lib.types.str;
				default = "main";
			};

			description = lib.mkOption {
				type = lib.types.str;
				default = "Main";
			};
		};

		work.user = {
			username = lib.mkOption {
				type = lib.types.str;
				default = "work";
			};

			description = lib.mkOption {
				type = lib.types.str;
				default = "Work";
			};
		};
	};

	config.main.user = {
		username = "stef";
		description = "Stefanos";
	};

	imports = [
		# Auto-generated configuration by NixOS
		./hardware-configuration.nix

		# Custom configuration
		./bootloader
		./hardware # Enable various hardware capabilities
		./hardware/amd/radeon.nix
		./hardware/amd/ryzen.nix
		#./hardware/intel.nix
		#./hardware/laptop.nix
		./hardware/mounts.nix # Disks to mount on startup
		#./hardware/nvidia.nix
		./hardware/virtualisation.nix
		./system/desktop
		./system/desktop/gnome
#		./system/desktop/hyprland
		./system/programs
		./system/users
	];

	config.system.stateVersion = "22.05"; # Do not change without checking the docs
}
