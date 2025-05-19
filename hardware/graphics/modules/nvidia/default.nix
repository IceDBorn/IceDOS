{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  graphics = cfg.hardware.graphics;
  powerLimit = graphics.nvidia.powerLimit;
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11.bin;
in
mkIf (graphics.enable && graphics.nvidia.enable) {
  services.xserver.videoDrivers = [ "nvidia" ]; # Install the nvidia drivers

  hardware.nvidia = {
    modesetting.enable = true;
    open = graphics.nvidia.openDrivers;

    package =
      if (graphics.nvidia.beta) then
        config.boot.kernelPackages.nvidiaPackages.beta
      else
        config.boot.kernelPackages.nvidiaPackages.stable;

    prime = mkIf (cfg.hardware.devices.laptop) {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Enable nvidia gpu acceleration for containers
  virtualisation.docker.enableNvidia = (
    cfg.system.virtualisation.containerManager.enable
    && !cfg.system.virtualisation.containerManager.usePodman
  );

  virtualisation.podman.enableNvidia = (
    cfg.system.virtualisation.containerManager.enable
    && cfg.system.virtualisation.containerManager.usePodman
  );

  icedos.internals.toolset.commands = mkIf (cfg.hardware.devices.laptop) [
    (
      let
        command = "force-nvidia";
      in
      {
        bin = "${pkgs.writeShellScript command ''
          export __NV_PRIME_RENDER_OFFLOAD=1
          export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export __VK_LAYER_NV_optimus=NVIDIA_only
          exec "$@"
        ''}";

        command = command;
        help = "forces command to use nvidia gpu";
      }
    )
  ];

  nixpkgs.config.cudaSupport = graphics.nvidia.cuda;

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
      ExecStart = "${nvidia_x11}/bin/nvidia-smi --power-limit=${toString (powerLimit.value)}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
