{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    length
    mkIf
    ;

  cfg = config.icedos;
  monitorsLength = length (monitors);
  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
  monitors = cfg.hardware.monitors;
  users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
in
{
  home-manager.users = mapAttrsAndKeys (
    user:
    let
      username = cfg.system.users.${user}.username;
    in
    {
      ${username} = mkIf (cfg.desktop.hyprland.enable) {
        home.file.".config/hypr/hyprland.conf".text = ''
          env = XDG_CURRENT_DESKTOP,Hyprland
          env = XDG_SESSION_TYPE,wayland
          env = XDG_SESSION_DESKTOP,Hyprland
          env = QT_AUTO_SCREEN_SCALE_FACTOR,1
          env = QT_QPA_PLATFORM,wayland;xcb

          $mainMod = SUPER
          ${lib.concatImapStrings (
            i: m:
            let
              name = m.name;
              resolution = m.resolution;
              refreshRate = builtins.toString (m.refreshRate);
              position = builtins.toString (m.position);
              scaling = builtins.toString (m.scaling);
              deckRotation = if (m.name == "eDP-1" && cfg.hardware.devices.steamdeck) then ",transform,3" else "";

              extraBind =
                if (i == 4) then
                  "CTRL_RIGHT"
                else if (i == 3) then
                  "ALT"
                else if (i == 2) then
                  "CTRL_LEFT"
                else
                  "";
            in
            lib.concatLines (
              [ "monitor = ${name},${resolution}@${refreshRate},${position},${scaling}${deckRotation}" ]
              ++ builtins.genList (
                w:
                let
                  cw = builtins.toString ((w + 1) + ((i - 1) * 10));
                  cb = if (w == 9) then "0" else "${toString (w + 1)}";
                  default = if (w == 0) then ",default:true" else "";
                in
                "workspace = ${cw},monitor:${name}${default}\nbind = $mainMod ${extraBind},${cb},workspace,${cw}\nbind = $mainMod SHIFT ${extraBind},${cb},movetoworkspace,${cw}"
              ) 10
            )
          ) monitors}
          env = WLR_DRM_NO_ATOMIC,1

          general {
            allow_tearing = true
            col.active_border = rgb(505050)
            col.inactive_border = rgb(000000)
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

          # Desktop usage
          bind = $mainMod, R, exec, rofi -show drun
          bind = $mainMod, V, exec, rofi -modi clipboard:${pkgs.cliphist}/bin/cliphist-rofi-img -show clipboard -show-icons
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

          # Switch to prev/next workspace
          bind = $mainMod ALT, left, workspace, e-1
          bind = $mainMod ALT, right, workspace, e+1

          # Move active windows to prev/next workspace
          bind = $mainMod SHIFT ALT, left, movetoworkspace, e-1
          bind = $mainMod SHIFT ALT, right, movetoworkspace, e+1

          # Scroll through existing workspaces with mod key + scroll
          bind = $mainMod, mouse_down, workspace, e-1
          bind = $mainMod, mouse_up, workspace, e+1

          # Move/resize windows with mod key + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          ${
            let
              browsers = "librewolf|zen-alpha";
              media-tools = "blueberry.py|org.pulseaudio.pavucontrol|valent";
              messengers = "WebCord|Signal|pwas|signal";
            in
            if (monitorsLength >= 3) then
              ''
                windowrulev2 = workspace 1 silent, class:^(${browsers})$
                windowrulev2 = workspace 2 silent, class:^(dev.zed.Zed)$
                windowrulev2 = workspace 3 silent, class:^(steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
                windowrulev2 = workspace 11 silent, class:^(${messengers})$
                windowrulev2 = workspace 12 silent, class:^(org\.gnome\.Nautilus)$
                windowrulev2 = workspace 13 silent, class:^(task-managers)$ # Task manager
                windowrulev2 = workspace 14 silent, class:^(terminals)$ # Terminal
                windowrulev2 = workspace 21 silent, class:^(Steam|steam)$, title:^((?!notificationtoasts.*).)*$
                windowrulev2 = workspace 21 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
                windowrulev2 = workspace 22 silent, class:^(${media-tools})$
              ''
            else if (monitorsLength == 2) then
              ''
                windowrulev2 = workspace 1 silent, class:^(${browsers})$
                windowrulev2 = workspace 2 silent, class:^(dev.zed.Zed)$
                windowrulev2 = workspace 3 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
                windowrulev2 = workspace 3 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
                windowrulev2 = workspace 11 silent, class:^(${messengers})$
                windowrulev2 = workspace 12 silent, class:^(org\.gnome\.Nautilus)$
                windowrulev2 = workspace 13 silent, class:^(${media-tools})$
                windowrulev2 = workspace 14 silent, class:^(task-managers)$ # Task manager
                windowrulev2 = workspace 15 silent, class:^(terminals)$ # Terminal
              ''
            else if (user != "work") then
              ''
                windowrulev2 = workspace 1 silent, class:^(${browsers})$
                windowrulev2 = workspace 2 silent, class:^(dev.zed.Zed)$
                windowrulev2 = workspace 3 silent, class:^(${messengers})$
                windowrulev2 = workspace 4 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
                windowrulev2 = workspace 4 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
                windowrulev2 = workspace 5 silent, class:^(org\.gnome\.Nautilus)$
                windowrulev2 = workspace 6 silent, class:^(${media-tools})$
                windowrulev2 = workspace 7 silent, class:^(task-managers)$ # Task Manager
                windowrulev2 = workspace 8 silent, class:^(terminals)$ # Terminal
              ''
            else
              ''
                windowrulev2 = workspace 1 silent, class:^(${browsers})$
                windowrulev2 = workspace 2 silent, class:^(dev.zed.Zed)$
                windowrulev2 = workspace 3 silent, class:^(${messengers})$
                windowrulev2 = workspace 4 silent, class:^(org\.gnome\.Nautilus)$
                windowrulev2 = workspace 5 silent, class:^(${media-tools})$
                windowrulev2 = workspace 6 silent, class:^(task-managers)$ # Task Manager
                windowrulev2 = workspace 7 silent, class:^(terminals)$ # Terminal
              ''
          }

          # Hide maximized window borders
          windowrulev2 = noborder, fullscreen:1

          # Tile windows
          windowrulev2 = tile, class:^(Godot.*|Steam|steam_app_.*|photoshop\.exe|DesktopEditors)$
          windowrulev2 = tile, title:^(.*Steam[A-Za-z0-9\s]*)$

          # Pin floating windows
          windowrulev2 = pin, class:(gcr-prompter)

          # Center windows
          windowrulev2 = center, class:(gcr-prompter)

          # Size windows
          windowrulev2 = size 40% 30%, class:(gcr-prompter)

          # Force focus on windows
          windowrulev2 = stayfocused, class:(gcr-prompter)

          # Dim around windows
          windowrulev2 = dimaround, class:(gcr-prompter)

          # Remove initial focus from apps
          windowrulev2 = noinitialfocus, class:^(steam)$, title:^(notificationtoasts.*)$, floating:1

          exec-once = hyprland-startup

          ${
            if (cfg.desktop.hyprland.hyprexpo) then
              ''
                plugin = ${inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo}/lib/libhyprexpo.so
                bind = $mainMod, TAB, hyprexpo:expo, toggle
                plugin {
                  hyprexpo {
                    columns = 3
                    gap_size = 5
                    bg_col = rgb(000000)
                    workspace_method = center current
                    enable_gesture = true
                    gesture_distance = 300
                    gesture_positive = true
                  }
                }
              ''
            else
              ""
          }

          ${
            if (cfg.desktop.hyprland.cs2fix.enable) then
              ''
                plugin = ${
                  inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
                }/lib/libcsgo-vulkan-fix.so
                plugin {
                  csgo-vulkan-fix {
                    res_w = ${builtins.toString (cfg.desktop.hyprland.cs2fix.width)}
                    res_h = ${builtins.toString (cfg.desktop.hyprland.cs2fix.height)}
                    class = SDL Application
                  }
                }
              ''
            else
              ""
          }
        '';
      };
    }
  ) users;
}
