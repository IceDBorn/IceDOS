{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.gpus.amd;
in
mkIf (cfg.enable) {
  boot = {
    initrd.kernelModules = [ "amdgpu" ]; # Use the amdgpu drivers upon boot
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ]; # Unlock all gpu controls
  };

  nixpkgs.config.rocmSupport = cfg.rocm;
}
