{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  undervolt = cfg.hardware.cpus.ryzen.undervolt;
in
mkIf (undervolt.enable) {
  environment.systemPackages = [
    pkgs.zenstates
  ];

  systemd.services.zenstates = {
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
      ExecStart = "${pkgs.zenstates}/bin/zenstates ${undervolt.value}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
