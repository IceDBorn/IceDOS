{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatMapStrings makeBinPath;
  cfg = config.icedos;
  session = "hyprland-uwsm.desktop";
in
{
  services.greetd = {
    enable = true;

    settings = {
      initial_session =
        let
          command = "uwsm-initial-session";
          uwsm = "${pkgs.uwsm}/bin/uwsm";
        in
        {
          command = "${
            makeBinPath [
              (pkgs.writeScriptBin command ''
                if ${uwsm} check may-start && ${uwsm} select; then
                  exec ${uwsm} start ${session}
                fi
              '')
            ]
          }/bin/${command}";

          user = "icedborn";
        };

      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config ${pkgs.writeText "hyprland.conf" ''
          ${concatMapStrings (
            m:
            let
              getMonitorRotation =
                m:
                if (m.name == "eDP-1" && cfg.hardware.devices.steamdeck) then
                  ",transform,3"
                else
                  ",transform,${builtins.toString m.rotation}";

              name = m.name;
              resolution = m.resolution;
              refreshRate = builtins.toString (m.refreshRate);
              position = builtins.toString (m.position);
              scaling = builtins.toString (m.scaling);
              rotation = getMonitorRotation m;
              bitDepth = if (m.tenBit) then ",bitdepth,10" else "";
            in
            if (m.disable) then
              "monitor = ${name},disable"
            else
              "monitor = ${name},${resolution}@${refreshRate},${position},${scaling}${rotation}${bitDepth}"
          ) cfg.hardware.monitors}


          exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit

          misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              disable_hyprland_qtutils_check = true
          }
        ''}";

        programs.regreet = {
          enable = true;

          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };

          cursorTheme = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
          };

          iconTheme = {
            name = "Tela-black-dark";
            package = pkgs.tela-icon-theme;
          };

          extraCss = ''
            @define-color accent_bg_color ${cfg.internals.accentColor};
            @define-color accent_color @accent_bg_color;

            :root {
              --accent-bg-color: @accent_bg_color;
            }
          '';
        };
      };
    };
  };
}
