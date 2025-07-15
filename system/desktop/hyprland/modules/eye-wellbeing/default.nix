{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    makeBinPath
    mapAttrs
    ;

  cfg = config.icedos;
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{
  home-manager.users = mapAttrs (user: _: {
    systemd.user = {
      services.eye-wellbeing = {
        Unit.Description = "Eye Wellbeing - Informs user for periodical eye rest";
        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = ''
            ${
              makeBinPath [
                (pkgs.writeShellScriptBin "eye-wellbeign" ''
                  "${notify-send}" "System" "Take a 20-second break to look at something 6 meters away"
                '')
              ]
            }/eye-wellbeign
          '';
        };
      };

      timers.eye-wellbeing = {
        Unit.Description = "Timer for eye-wellbeing";

        Timer = {
          Unit = "eye-wellbeing";
          OnCalendar = "*:0/20";
          AccuracySec = "20m";
        };

        Install.WantedBy = [ "timers.target" ];
      };
    };
  }) cfg.system.users;
}
