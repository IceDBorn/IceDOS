{ config, ... }:

{
  hardware.cpu.intel.updateMicrocode = config.hardware.cpu.intel.enable;
  services.throttled.enable = config.hardware.cpu.intel.enable;
}
