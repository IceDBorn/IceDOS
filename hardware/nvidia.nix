{ config, pkgs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in lib.mkIf config.nvidia.enable {
  services.xserver.videoDrivers = [ "nvidia" ]; # Install the nvidia drivers

  hardware.nvidia.modesetting.enable = true; # Required for wayland

  virtualisation.docker.enableNvidia =
    true; # Enable nvidia gpu acceleration for docker

  environment.systemPackages =
    [ pkgs.nvtop-nvidia ] # Monitoring tool for nvidia GPUs
    ++ (if (config.laptop.enable) then
      [
        nvidia-offload
      ] # Use nvidia-offload to launch programs using the nvidia GPU
    else
      [ ]);

  # Set nvidia gpu power limit
  systemd.services.nv-power-limit = lib.mkIf config.nvidia.power-limit.enable {
    enable = true;
    description = "Nvidia power limit control";
    after = [ "syslog.target" "systemd-modules-load.service" ];

    unitConfig = {
      ConditionPathExists =
        "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

    serviceConfig = {
      User = "root";
      ExecStart =
        "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi  --power-limit=${config.nvidia.power-limit.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
