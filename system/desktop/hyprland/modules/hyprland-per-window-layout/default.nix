{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  package = pkgs.hyprland-per-window-layout;
in
{
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.hyprland-per-window-layout = {
      Unit.Description = "Hyprland per window layout";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/bin/hyprland-per-window-layout";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
