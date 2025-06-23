{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.drivers;
in
mkIf (cfg.rtl8821ce) {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ rtl8821ce ];
    blacklistedKernelModules = [ "rtw88_8821ce" ];
    kernelModules = [ "rtl8821ce" ];
  };
}
