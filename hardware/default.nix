{
	hardware = {
		opengl = {
			enable = true;
			driSupport32Bit = true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
		};

		xpadneo.enable = true; # Enable XBOX Gamepad bluetooth driver
		bluetooth.enable = true;
		uinput.enable = true; # Enable uinput support
	};

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
		"v4l2loopback" # Virtual camera
		"xpadneo"
		"uinput"
	];
}
