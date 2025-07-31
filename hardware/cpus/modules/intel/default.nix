{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.cpus.intel;
in
mkIf (cfg) {
  hardware.cpu.intel.updateMicrocode = true;
  services.throttled.enable = true;
}
