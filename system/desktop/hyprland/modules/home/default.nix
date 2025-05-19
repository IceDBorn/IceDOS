{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatLists
    filter
    genList
    imap
    makeBinPath
    mapAttrs
    mkIf
    ;

  animations = cfg.desktop.hyprland.settings.animations;
  cfg = config.icedos;
  monitors = cfg.hardware.monitors;

  getMonitorRotation =
    m:
    if (m.name == "eDP-1" && cfg.hardware.devices.steamdeck) then
      ",transform,3"
    else
      ",transform,${toString m.rotation}";

  workspaceBinds =
    bind: command:
    (concatLists (
      imap (
        i: _:
        genList (
          w:
          let
            cw = toString ((w + 1) + ((i - 1) * 10));
            cb = if (w == 9) then "0" else "${toString (w + 1)}";

            extraBind =
              if (i == 4) then
                "CTRL ALT"
              else if (i == 3) then
                "ALT"
              else if (i == 2) then
                "CTRL"
              else
                "";
          in
          if (i < 5) then "$mainMod ${bind} ${extraBind},${cb},${command},${cw}" else ""
        ) 10
      ) (filter (m: !m.disable) monitors)
    ));
in
{
  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";

        animation =
          if (animations.enable) then "global, 1, ${toString (animations.speed)}, bezier" else "global, 0";

        bezier = mkIf (animations.enable) "bezier, ${animations.bezierCurve}";

        bind =
          [
            "$mainMod, Q, killactive"
            "$mainMod, T, togglefloating"
            "$mainMod, S, togglesplit"
            "$mainMod, F, fullscreen, 0"
            "$mainMod, M, fullscreen, 1"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            "$mainMod SHIFT, left, movewindow, l"
            "$mainMod SHIFT, right, movewindow, r"
            "$mainMod SHIFT, up, movewindow, u"
            "$mainMod SHIFT, down, movewindow, d"
            "$mainMod ALT, left, workspace, e-1"
            "$mainMod ALT, right, workspace, e+1"
            "$mainMod SHIFT ALT, left, movetoworkspace, e-1"
            "$mainMod SHIFT ALT, right, movetoworkspace, e+1"
            "$mainMod, mouse_down, workspace, e-1"
            "$mainMod, mouse_up, workspace, e+1"
          ]
          ++ workspaceBinds "" "workspace"
          ++ workspaceBinds "SHIFT" "movetoworkspace";

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [ ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        decoration = {
          rounding = 5;
        };

        env = [
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "WLR_DRM_NO_ATOMIC,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
        ];

        exec-once = [
          ''
            ${
              makeBinPath [
                (pkgs.writeShellScriptBin "hyprland-startup" cfg.desktop.hyprland.settings.startupScript)
              ]
            }/hyprland-startup
          ''
        ];

        general = {
          allow_tearing = true;
          "col.active_border" = "rgb(505050)";
          "col.inactive_border" = "rgb(000000)";
          gaps_in = 0;
          gaps_out = 0;
          resize_on_border = true;
        };

        input = {
          accel_profile = "flat";
          follow_mouse = cfg.desktop.hyprland.settings.followMouse;
          kb_layout = "us,gr";
          kb_options = "grp:win_space_toggle";
        };

        misc = {
          "col.splash" = "rgb(000000)";
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
          new_window_takes_over_fullscreen = 1;
        };

        monitor = (
          map (
            m:
            let
              name = m.name;
              resolution = m.resolution;
              refreshRate = toString (m.refreshRate);
              position = toString (m.position);
              scaling = toString (m.scaling);
              rotation = getMonitorRotation m;
              bitDepth = if (m.tenBit) then ",bitdepth,10" else "";
            in
            if (m.disable) then
              "${name},disable"
            else
              "${name},${resolution}@${refreshRate},${position},${scaling}${rotation}${bitDepth}"
          ) monitors
        );

        windowrulev2 = [
          "noborder, fullscreen:1" # Hide maximized window borders
        ] ++ cfg.desktop.hyprland.settings.windowRules;

        workspace = (
          concatLists (
            imap (
              i: m:
              let
                name = m.name;
              in
              genList (
                w:
                let
                  cw = toString ((w + 1) + ((i - 1) * 10));
                  default = if (w == 0) then ",default:true" else "";
                in
                "${cw},monitor:${name}${default}"
              ) 10
            ) (filter (m: !m.disable) monitors)
          )
        );
      };
    };
  }) cfg.system.users;
}
