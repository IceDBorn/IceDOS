{ config, pkgs, ... }:

let
	nvidia-power-limit = "242";
in
{
	services.xserver.videoDrivers = [ "nvidia" ]; # Install the nvidia drivers

	hardware.nvidia = {
		modesetting.enable = true; # Required for wayland
		# Patch the driver for nvfbc
		package = config.nur.repos.arc.packages.nvidia-patch.override {
			nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
		};
	};

	virtualisation.docker.enableNvidia = true; # Enable nvidia gpu acceleration for docker

	environment.systemPackages = [ pkgs.nvtop-nvidia ]; # Monitoring tool for nvidia GPUs

	# Set nvidia gpu power limit
	systemd.services.nv-power-limit = {
		enable = true;
		description = "Nvidia power limit control";
		after = [ "syslog.target" "systemd-modules-load.service" ];

		unitConfig = {
			ConditionPathExists = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
		};

		serviceConfig = {
			User = "root";
			ExecStart = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi  --power-limit=${nvidia-power-limit}";
		};

		wantedBy = [ "multi-user.target" ];
	};
}
