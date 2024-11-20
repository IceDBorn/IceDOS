{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.drivers.rtl8821ce;
in mkIf cfg {
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ rtl8821ce ];
    blacklistedKernelModules = [ "rtw88_8821ce" ];
    kernelModules = [ "rtl8821ce" ];
  };
}
