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
    mkIf
    ;

  cfg = config.icedos;
  hyproled = cfg.desktop.hyprland.plugins.hyproled;
  startWidth = toString (hyproled.startWidth);
  startHeight = toString (hyproled.startHeight);
  endWidth = toString (hyproled.endWidth);
  endHeight = toString (hyproled.endHeight);
  area = "-a ${startWidth}:${startHeight}:${endWidth}:${endHeight}";
in
mkIf (hyproled.enable) {
  environment.systemPackages = [ pkgs.hyproled ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user = {
      services.hyproled = {
        Unit.Description = "Hyproled - Prevents OLED burn-in";
        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          ExecStart = ''
            ${
              makeBinPath [
                (pkgs.writeShellScriptBin "hyproled-wrapper" ''
                  hyproled ${area}
                  hyproled -s ${area}
                  hyproled off
                '')
              ]
            }/hyproled-wrapper
          '';

          Nice = "-20";
        };
      };

      timers.hyproled = {
        Unit.Description = "Timer for hyproled";

        Timer = {
          Unit = "hyproled.service";
          Persistent = true;
          OnBootSec = "1h";
          OnUnitActiveSec = "1h";
          AccuracySec = "1h";
        };

        Install.WantedBy = [ "timers.target" ];
      };
    };
  }) cfg.system.users;
}
