{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  package = pkgs.hyprpolkitagent;
in
{
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.hyprpolkitagent = {
      Unit.Description = "Hyprpolkitagent - Polkit authentication agent";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/libexec/hyprpolkitagent";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
