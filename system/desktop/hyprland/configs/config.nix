{ config, lib, ... }:

let
  inherit (lib) attrNames filter foldl' mkIf;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);

  cfg = config.icedos;
  monitors = cfg.hardware.monitors;

  deckRotation = if (cfg.hardware.steamdeck) then ",transform,3" else "";
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let
      username = cfg.system.user.${user}.username;
      singleMonWRules = if (user != "work") then ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(nvchad)$
        windowrulev2 = workspace 3 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 4 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 4 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
        windowrulev2 = workspace 5 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 6 silent, class:^(task-managers)$ # Task Manager
        windowrulev2 = workspace 7 silent, class:^(terminals)$ # Terminal
      '' else ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(nvchad)$
        windowrulev2 = workspace 3 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 4 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 5 silent, class:^(task-managers)$ # Task Manager
        windowrulev2 = workspace 6 silent, class:^(terminals)$ # Terminal
      '';

      dualMonWRules = ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(nvchad)$
        windowrulev2 = workspace 3 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 3 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
        windowrulev2 = workspace 11 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 12 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 13 silent, class:^(task-managers)$ # Task manager
        windowrulev2 = workspace 14 silent, class:^(terminals)$ # Terminal
      '';

      tripleMonWRules = ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(nvchad)$
        windowrulev2 = workspace 3 silent, class:^(steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 21 silent, class:^(Steam|steam)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 21 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
        windowrulev2 = workspace 11 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 12 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 13 silent, class:^(task-managers)$ # Task manager
        windowrulev2 = workspace 14 silent, class:^(terminals)$ # Terminal
      '';

      finalWRules = if (monitors.main.enable && monitors.second.enable
        && !monitors.third.enable) then
        dualMonWRules
      else if (monitors.main.enable && monitors.second.enable
        && monitors.third.enable) then
        tripleMonWRules
      else
        singleMonWRules;
    in {
      ${username} = mkIf (cfg.desktop.hyprland.enable) {
        home.file.".config/hypr/hyprland.conf".text = ''
          # See available monitors with 'hyprctl monitors'
          monitor = ${monitors.main.name},${monitors.main.resolution}@${monitors.main.refreshRate},${monitors.main.position},${monitors.main.scaling}${deckRotation}
          workspace = 1, monitor:${monitors.main.name}, default:true
          workspace = 2, monitor:${monitors.main.name}
          workspace = 3, monitor:${monitors.main.name}
          workspace = 4, monitor:${monitors.main.name}
          workspace = 5, monitor:${monitors.main.name}
          workspace = 6, monitor:${monitors.main.name}
          workspace = 7, monitor:${monitors.main.name}
          workspace = 8, monitor:${monitors.main.name}
          workspace = 9, monitor:${monitors.main.name}
          workspace = 10, monitor:${monitors.main.name}

          monitor = ${monitors.second.name},${monitors.second.resolution}@${monitors.second.refreshRate},${monitors.second.position},${monitors.second.scaling}
          workspace = 11, monitor:${monitors.second.name}, default:true
          workspace = 12, monitor:${monitors.second.name}
          workspace = 13, monitor:${monitors.second.name}
          workspace = 14, monitor:${monitors.second.name}
          workspace = 15, monitor:${monitors.second.name}
          workspace = 16, monitor:${monitors.second.name}
          workspace = 17, monitor:${monitors.second.name}
          workspace = 18, monitor:${monitors.second.name}
          workspace = 19, monitor:${monitors.second.name}
          workspace = 20, monitor:${monitors.second.name}

          monitor = ${monitors.third.name},${monitors.third.resolution}@${monitors.third.refreshRate},${monitors.third.position},${monitors.third.scaling}
          workspace = 21, monitor:${monitors.third.name}, default:true
          workspace = 22, monitor:${monitors.third.name}
          workspace = 23, monitor:${monitors.third.name}
          workspace = 24, monitor:${monitors.third.name}
          workspace = 25, monitor:${monitors.third.name}
          workspace = 26, monitor:${monitors.third.name}
          workspace = 27, monitor:${monitors.third.name}
          workspace = 28, monitor:${monitors.third.name}
          workspace = 29, monitor:${monitors.third.name}
          workspace = 30, monitor:${monitors.third.name}

          env = WLR_DRM_NO_ATOMIC,1

          general {
            allow_tearing = true
            col.active_border = rgb(505050)
            col.inactive_border = rgb(000000)
            cursor_inactive_timeout = 10
            gaps_in = 0
            gaps_out = 0
            resize_on_border = true
          }

          decoration {
            drop_shadow = false
            rounding = 5
          }

          input {
            accel_profile = flat
            follow_mouse = 2
            kb_layout = us,gr
            kb_options = grp:win_space_toggle
          }

          misc {
            col.splash = rgb(000000)
            disable_hyprland_logo = true
            disable_splash_rendering = true
            key_press_enables_dpms = true
            mouse_move_enables_dpms = true
            new_window_takes_over_fullscreen = 1
            vrr = 2
          }

          # Set mod key to Super
          $mainMod = SUPER

          #Desktop usage
          bind = $mainMod, R, exec, rofi -show drun
          bind = $mainMod, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons
          bind = , Print, exec, grimblast copy output
          bind = SHIFT, Print, exec, grimblast edit output
          bind = $mainMod, Print, exec, grimblast --freeze copy area
          bind = $mainMod SHIFT, Print, exec, grimblast --freeze edit area
          bind = ALT, Print, exec, grimblast copy
          bind = $mainMod ALT, Print, exec, grimblast edit
          bind = $mainMod, L, exec, hyprlock-wrapper lock force
          bind = $mainMod SHIFT, L, exec, wleave
          bind = $mainMod, N, exec, swaync-client -t -sw
          bind = $mainMod SHIFT, N, exec, swaync-client -d -sw
          bind = $mainMod, C, exec, hyprpicker --autocopy
          bind = $mainMod SHIFT, P, exec, hyprfreeze -a

          # Window control
          bind = $mainMod, Q, killactive
          bind = $mainMod, T, togglefloating,
          bind = $mainMod, P, pseudo
          bind = $mainMod, S, togglesplit
          bind = $mainMod, F, fullscreen, 0
          bind = $mainMod, M, fullscreen, 1

          # Move focus with mod key + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Move position with mod key, shift + arrow keys
          bind = $mainMod SHIFT, left, movewindow, l
          bind = $mainMod SHIFT, right, movewindow, r
          bind = $mainMod SHIFT, up, movewindow, u
          bind = $mainMod SHIFT, down, movewindow, d

          # Switch workspaces with mod key + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10
          bind = $mainMod CTRL, 1, workspace, 11
          bind = $mainMod CTRL, 2, workspace, 12
          bind = $mainMod CTRL, 3, workspace, 13
          bind = $mainMod CTRL, 4, workspace, 14
          bind = $mainMod CTRL, 5, workspace, 15
          bind = $mainMod CTRL, 6, workspace, 16
          bind = $mainMod CTRL, 7, workspace, 17
          bind = $mainMod CTRL, 8, workspace, 18
          bind = $mainMod CTRL, 9, workspace, 19
          bind = $mainMod CTRL, 0, workspace, 20
          bind = $mainMod ALT, 1, workspace, 21
          bind = $mainMod ALT, 2, workspace, 22
          bind = $mainMod ALT, 3, workspace, 23
          bind = $mainMod ALT, 4, workspace, 24
          bind = $mainMod ALT, 5, workspace, 25
          bind = $mainMod ALT, 6, workspace, 26
          bind = $mainMod ALT, 7, workspace, 27
          bind = $mainMod ALT, 8, workspace, 28
          bind = $mainMod ALT, 9, workspace, 29
          bind = $mainMod ALT, 0, workspace, 30

          # Switch to prev/next workspace
          bind = $mainMod ALT, left, workspace, e-1
          bind = $mainMod ALT, right, workspace, e+1

          # Move active window to a workspace with mod key + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10
          bind = $mainMod SHIFT CTRL, 1, movetoworkspace, 11
          bind = $mainMod SHIFT CTRL, 2, movetoworkspace, 12
          bind = $mainMod SHIFT CTRL, 3, movetoworkspace, 13
          bind = $mainMod SHIFT CTRL, 4, movetoworkspace, 14
          bind = $mainMod SHIFT CTRL, 5, movetoworkspace, 15
          bind = $mainMod SHIFT CTRL, 6, movetoworkspace, 16
          bind = $mainMod SHIFT CTRL, 7, movetoworkspace, 17
          bind = $mainMod SHIFT CTRL, 8, movetoworkspace, 18
          bind = $mainMod SHIFT CTRL, 9, movetoworkspace, 19
          bind = $mainMod SHIFT CTRL, 0, movetoworkspace, 20
          bind = $mainMod SHIFT ALT, 1, movetoworkspace, 21
          bind = $mainMod SHIFT ALT, 2, movetoworkspace, 22
          bind = $mainMod SHIFT ALT, 3, movetoworkspace, 23
          bind = $mainMod SHIFT ALT, 4, movetoworkspace, 24
          bind = $mainMod SHIFT ALT, 5, movetoworkspace, 25
          bind = $mainMod SHIFT ALT, 6, movetoworkspace, 26
          bind = $mainMod SHIFT ALT, 7, movetoworkspace, 27
          bind = $mainMod SHIFT ALT, 8, movetoworkspace, 28
          bind = $mainMod SHIFT ALT, 9, movetoworkspace, 29
          bind = $mainMod SHIFT ALT, 0, movetoworkspace, 30

          # Move active windows to prev/next workspace
          bind = $mainMod SHIFT ALT, left, movetoworkspace, e-1
          bind = $mainMod SHIFT ALT, right, movetoworkspace, e+1

          # Scroll through existing workspaces with mod key + scroll
          bind = $mainMod, mouse_down, workspace, e-1
          bind = $mainMod, mouse_up, workspace, e+1

          # Move/resize windows with mod key + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # Move apps to workspaces
          ${finalWRules}

          # Hide maximized window borders
          windowrulev2 = noborder, fullscreen:1

          # Inhibit idle for apps
          windowrulev2 = idleinhibit focus, class:^(org\.gnome\.clocks|Steam|steam|steam_app_.*)$

          # Tile apps
          windowrulev2 = tile, class:^(Godot.*|Steam|steam_app_.*|photoshop\.exe|DesktopEditors)$
          windowrulev2 = tile, title:^(.*Steam[A-Za-z0-9\s]*)$

          # Float apps
          windowrulev2 = float, class:^(feh)$

          # Pin floating apps
          windowrulev2 = pin, class:^(feh)$

          # Hide apps
          windowrulev2 = float, title:^(Firefox — Sharing Indicator|Wine System Tray)$
          windowrulev2 = size 0 0, title:^(Firefox — Sharing Indicator|Wine System Tray)$

          # Remove initial focus from apps
          windowrulev2 = noinitialfocus, class:^(steam)$, title:^(notificationtoasts.*)$, floating:1

          exec-once = hyprland-startup
        '';
      };
    }) users;
}
