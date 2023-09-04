{ pkgs, lib, config, ... }:

lib.mkIf config.laptop.enable {
  services.auto-cpufreq.enable = config.laptop.auto-cpufreq.enable;
  environment.systemPackages = [ pkgs.brightnessctl ];

  hardware.nvidia.prime = lib.mkIf config.nvidia.enable {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
