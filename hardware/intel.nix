{ config, ... }:

{
  hardware.cpu.intel.updateMicrocode = config.intel.enable;
  services.throttled.enable = config.intel.enable;
}
