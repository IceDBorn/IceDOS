{ config, pkgs, ... }:

let
    nvidia-power-limit = "180";
in
{
    # Install the nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    # Required for wayland
    hardware.nvidia.modesetting.enable = true;

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
