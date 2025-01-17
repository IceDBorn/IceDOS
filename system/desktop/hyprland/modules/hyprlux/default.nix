{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  programs.hyprlux = {
    enable = true;

    night_light = {
      enabled = true;
      start_time = "21:00";
      end_time = "07:00";
      temperature = 5000;
    };

    vibrance_configs = [
      {
        window_class = "cs2";
        window_title = "";
        strength = 100;
      }
    ];
  };

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.hyprlux = {
      Unit.Description = "Hyprlux - Automates vibrance and night light control";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${inputs.hyprlux.packages.${pkgs.system}.default}/bin/hyprlux";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
