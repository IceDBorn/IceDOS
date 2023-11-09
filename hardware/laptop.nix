{ pkgs, lib, config, ... }:

lib.mkIf config.hardware.laptop.enable {
  services.auto-cpufreq.enable = config.hardware.laptop.autoCpuFreq;
  environment.systemPackages = [ pkgs.brightnessctl ];

  hardware.nvidia.prime = lib.mkIf config.hardware.gpu.nvidia.enable {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
