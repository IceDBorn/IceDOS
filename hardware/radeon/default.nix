{
  config,
  lib,
  pkgs,
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

  environment.systemPackages = mkIf (cfg.lact) [ pkgs.lact ];
  nixpkgs.config.rocmSupport = cfg.rocm;

  # We are creating the lact daemon service manually because the provided one hangs
  systemd.services.lactd = mkIf (cfg.lact) {
    enable = true;
    description = "Radeon GPU monitor";
    after = [
      "syslog.target"
      "systemd-modules-load.service"
    ];

    unitConfig = {
      ConditionPathExists = "${pkgs.lact}/bin/lact";
    };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
