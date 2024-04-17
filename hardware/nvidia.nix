{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf optional;

  cfg = config.icedos;
  powerLimit = cfg.hardware.gpu.nvidia.powerLimit;
  nvidia_x11 = cfg.boot.kernelPackages.nvidia_x11.bin;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
mkIf (cfg.hardware.gpu.nvidia.enable) {
  services.xserver.videoDrivers = [ "nvidia" ]; # Install the nvidia drivers

  hardware.nvidia = {
    prime = mkIf (cfg.hardware.laptop) {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = true;
  };

  virtualisation.docker.enableNvidia = cfg.hardware.virtualisation.docker; # Enable nvidia gpu acceleration for docker

  environment.systemPackages =
    [ pkgs.nvtopPackages.nvidia ] # Monitoring tool for nvidia GPUs
    ++ optional (cfg.hardware.laptop) nvidia-offload; # Use nvidia-offload to launch programs using the nvidia GPU

  # Set nvidia gpu power limit
  systemd.services.nv-power-limit = mkIf (powerLimit.enable) {
    enable = true;
    description = "Nvidia power limit control";
    after = [
      "syslog.target"
      "systemd-modules-load.service"
    ];

    unitConfig = {
      ConditionPathExists = "${nvidia_x11}/bin/nvidia-smi";
    };

    serviceConfig = {
      User = "root";
      ExecStart = "${nvidia_x11}/bin/nvidia-smi --power-limit=${powerLimit.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
