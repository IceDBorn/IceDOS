{ config, ... }:

let
  cfg = config.icedos.hardware.cpus.intel;
in
{
  hardware.cpu.intel.updateMicrocode = cfg;
  services.throttled.enable = cfg;
}
