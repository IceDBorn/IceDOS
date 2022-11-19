{
	imports = [
    # AMD CPU/GPU
    ./amd
		# Disks to mount on startup
		./mounts.nix
		# Nvidia drivers, configuration and power limit
		./nvidia.nix
		# Virtualisation options
		./virtualisation.nix
	];

	hardware = {
		opengl = {
			enable = true;
			# Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
			driSupport32Bit = true;
		};
		# Enable XBOX Gamepad bluetooth driver
		xpadneo.enable = true;

		# Enable bluetooth
		bluetooth.enable = true;
	};

	 # This would allow steam link to run as a top priority application
	 # It can be enabled after nvidia fixes their driver
#	 security.wrappers = {
#		 gamescope = {
#			 owner = "root";
#			 group = "root";
#			 capabilities = "cap_sys_nice=eip";
#			 source = "${pkgs.unstable.gamescope}/bin/gamescope";
#		 };
#	 };

	# Set memory limits
	security.pam.loginLimits =
	[
		{
			domain = "*";
			type = "hard";
			item = "memlock";
			value = "2147483648";
		}

		{
			domain = "*";
			type = "soft";
			item = "memlock";
			value = "2147483648";
		}
	];

	boot.kernelModules = [
		"v4l2loopback" # Virtual camera for OBS
		"xpadneo" # XBOX Gamepad bluetooth driver
	];
}
