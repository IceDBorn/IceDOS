{ config, pkgs, ... }:

let
    nvidia-power-limit = "242";
in
{
    # Install the nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        # Required for wayland
        modesetting.enable = true;
        # Patch the driver for nvfbc
        package = pkgs.nur.repos.arc.packages.nvidia-patch.override {
            nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

    # Enable nvidia gpu acceleration for docker
    virtualisation.docker.enableNvidia = true;

    # Nvidia power limit
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
