{ pkgs, lib, config, ... }:

lib.mkIf config.amd.cpu.enable {
  boot.kernelModules = [ "msr" ]; # Needed for zenstates

  hardware.cpu.amd.updateMicrocode = true;

  # Ryzen cpu control
  systemd.services.zenstates = lib.mkIf config.amd.cpu.undervolt.enable {
    enable = true;
    description = "Ryzen Undervolt";
    after = [ "syslog.target" "systemd-modules-load.service" ];

    unitConfig = {
      ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
    };

    serviceConfig = {
      User = "root";
      ExecStart = "${pkgs.zenstates}/bin/zenstates ${config.amd.cpu.undervolt.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
