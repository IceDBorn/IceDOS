{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  package = pkgs.sysauth;
in
{
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.sysauth = {
      Unit.Description = "Sysauth - Polkit authentication agent";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/bin/sysauth";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
