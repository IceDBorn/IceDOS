{ pkgs, ... }:

{
	boot = {
		loader = {
			# Enable EFI boot
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};

			systemd-boot = {
				enable = true;
				# Keep the last 10 nixOS configurations
				configurationLimit = 10;
				# Select the highest resolution for the bootloader
				consoleMode = "max";
			};

			# Boot to default entry after 1 second
			timeout = 1;
		};
		# Use Zen kernel
		kernelPackages = pkgs.linuxPackages_zen;
	};
}
