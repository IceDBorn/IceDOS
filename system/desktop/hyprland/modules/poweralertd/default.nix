{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  package = pkgs.poweralertd;
in
{
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.poweralertd = {
      Unit.Description = "Poweralertd - UPower-powered power alerter";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/bin/poweralertd";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
