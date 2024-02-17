{ pkgs, lib, config, ... }:

let
  cfg = config.hardware.cpu.amd;
  kernelPackages = config.boot.kernelPackages;
in lib.mkIf cfg.enable {
  boot = {
    kernelModules = [ "msr" "zenpower" ];
    extraModulePackages = with kernelPackages; [ zenpower ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  # Ryzen cpu control
  systemd.services.zenstates = lib.mkIf cfg.undervolt.enable {
    enable = true;
    description = "Ryzen Undervolt";
    after = [ "syslog.target" "systemd-modules-load.service" ];

    unitConfig = { ConditionPathExists = "${pkgs.zenstates}/bin/zenstates"; };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.zenstates}/bin/zenstates ${cfg.undervolt.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
