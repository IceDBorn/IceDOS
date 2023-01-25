{ pkgs, config, ... }:

{
	boot = {
		loader = {
			# Allows discovery of UEFI disks
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};

			# Use systemd boot instead of grub
			systemd-boot = {
				enable = true;
				configurationLimit = 10;
				consoleMode = "max"; # Select the highest resolution for the bootloader
			};

			timeout = 1; # Boot default entry after 1 second
		};

		plymouth.enable = config.boot.animation.enable;
	};
}
