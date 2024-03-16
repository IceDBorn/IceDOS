{ config, ... }:

let cfg = config.icedos.hardware.cpu.intel.enable;
in {
  hardware.cpu.intel.updateMicrocode = cfg;
  services.throttled.enable = cfg;
}
