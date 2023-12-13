{ pkgs, lib, config, ... }:

lib.mkIf config.hardware.gpu.amd {
  boot.initrd.kernelModules = [ "amdgpu" ]; # Use the amdgpu drivers upon boot

  programs.corectrl = {
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff"; # Unlock all gpu controls
    };
  };

  environment.systemPackages = with pkgs; [
    nvtop-amd # GPU task manager
    lact # GPU overclocking tool
  ];

  # We are creating the lact daemon service manually because the provided one hangs
  systemd.services.lactd = {
    enable = true;
    description = "Radeon GPU monitor";
    after = [ "syslog.target" "systemd-modules-load.service" ];

    unitConfig = { ConditionPathExists = "${pkgs.lact}/bin/lact"; };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
