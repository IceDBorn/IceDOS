{ config, pkgs, lib, ... }:

{
	services.xserver.videoDrivers = lib.mkIf config.nvidia.enable [ "nvidia" ]; # Install the nvidia drivers

	hardware.nvidia = lib.mkIf config.nvidia.enable {
		modesetting.enable = true; # Required for wayland
		# Patch the driver for nvfbc
		package = config.nur.repos.arc.packages.nvidia-patch.override {
			nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
		};
	};

	virtualisation.docker.enableNvidia = config.nvidia.enable; # Enable nvidia gpu acceleration for docker

	environment.systemPackages = lib.mkIf config.nvidia.enable [ pkgs.nvtop-nvidia ]; # Monitoring tool for nvidia GPUs

	# Set nvidia gpu power limit
	systemd.services.nv-power-limit = lib.mkIf (config.nvidia.enable && config.nvidia.power-limit.enable) {
		enable = true;
		description = "Nvidia power limit control";
		after = [ "syslog.target" "systemd-modules-load.service" ];

		unitConfig = {
			ConditionPathExists = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
		};

		serviceConfig = {
			User = "root";
			ExecStart = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi  --power-limit=${config.nvidia.power-limit.value}";
		};

		wantedBy = [ "multi-user.target" ];
	};
}
