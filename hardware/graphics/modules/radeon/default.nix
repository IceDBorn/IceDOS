{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.graphics;
in
mkIf (cfg.enable && cfg.radeon.enable) {
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  };

  nixpkgs.config.rocmSupport = cfg.radeon.rocm;
}
