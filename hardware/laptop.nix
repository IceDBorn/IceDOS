{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.hardware;
in
mkIf (cfg.laptop.enable) {
  services.cpupower-gui.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    cpupower-gui
  ];

  hardware.nvidia.prime = mkIf (cfg.gpu.nvidia.enable) {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
