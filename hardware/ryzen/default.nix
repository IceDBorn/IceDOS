{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf optional;
  cfg = config.icedos.hardware.cpus.amd;
in
mkIf (cfg.enable) {
  boot = {
    kernelParams = [
      "amd-pstate=active"
      "amd_pstate.shared_mem=1"
    ];

    kernelModules = [
      "amd-pstate"
      "msr"
    ]
    ++ optional cfg.zenergy "zenergy";

    extraModulePackages = with config.boot.kernelPackages; mkIf (cfg.zenergy) [ zenergy ];
  };

  environment.systemPackages = mkIf (cfg.undervolt.enable) [
    pkgs.zenstates
  ];

  hardware.cpu.amd.updateMicrocode = true;

  # Ryzen cpu control
  systemd.services.zenstates = mkIf (cfg.undervolt.enable) {
    enable = true;
    description = "Ryzen Undervolt";
    after = [
      "syslog.target"
      "systemd-modules-load.service"
    ];

    unitConfig = {
      ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
    };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.zenstates}/bin/zenstates ${cfg.undervolt.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
