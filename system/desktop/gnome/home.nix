{ config, lib, ... }:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    optional
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = filter (user: cfg.system.user.${user}.enable == true) (attrNames cfg.system.user);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.user.${user}.username;
      in
      {
        ${username} = mkIf (cfg.desktop.gnome.enable) {

          dconf.settings = {
            "org/gnome/desktop/input-sources" = {
              # Use different keyboard language for each window
              per-window = true;
            };

            "org/gnome/desktop/interface" = {
              # Enable dark mode
              color-scheme = "prefer-dark";

              # Enable clock seconds
              clock-show-seconds = true;

              # Disable date
              clock-show-date = cfg.desktop.gnome.clock.date;
              clock-show-weekday = cfg.desktop.gnome.clock.weekday;

              show-battery-percentage = cfg.hardware.laptop;

              # Access the activity overview by moving the mouse to the top-left corner
              enable-hot-corners = cfg.desktop.gnome.hotCorners;
            };

            # Disable lockscreen notifications
            "org/gnome/desktop/notifications" = {
              show-in-lock-screen = false;
            };

            "org/gnome/desktop/wm/preferences" = {
              # Buttons to show in titlebars
              button-layout = cfg.desktop.gnome.titlebarLayout;
              num-workspaces = builtins.toString (cfg.desktop.gnome.workspaces.maxWorkspaces);
            };

            # Disable mouse acceleration
            "org/gnome/desktop/peripherals/mouse" = {
              accel-profile = "flat";
            };

            # Disable file history
            "org/gnome/desktop/privacy" = {
              remember-recent-files = false;
            };

            # Turn off screen
            "org/gnome/desktop/session" = {
              idle-delay =
                if (cfg.system.user.${user}.desktop.idle.disableMonitors.enable) then
                  cfg.system.user.${user}.desktop.idle.disableMonitors.seconds
                else
                  0;
            };

            # Set screen lock
            "org/gnome/desktop/screensaver" = {
              lock-enabled = cfg.system.user.${user}.desktop.idle.lock.enable;
              lock-delay = cfg.system.user.${user}.desktop.idle.lock.seconds;
            };

            # Disable system sounds
            "org/gnome/desktop/sound" = {
              event-sounds = false;
            };

            "org/gnome/mutter" = {
              # Enable window snapping to the edges of the screen
              edge-tiling = true;
              # Enable fractional scaling
              experimental-features = [ "scale-monitor-framebuffer" ];
              dynamic-workspaces = cfg.desktop.gnome.workspaces.dynamicWorkspaces;
            };

            "org/gnome/settings-daemon/plugins/power" = {
              # Auto suspend
              sleep-inactive-ac-type =
                if (cfg.system.user.${user}.desktop.idle.suspend.enable) then "suspend" else "nothing";
              # Auto suspend timeout
              sleep-inactive-ac-timeout = cfg.system.user.${user}.desktop.idle.suspend.seconds;
              # Power button shutdown
              power-button-action = cfg.desktop.gnome.powerButtonAction;
            };

            "org/gnome/shell" = {
              # Enable gnome extensions
              disable-user-extensions = false;
              # Set enabled gnome extensions
              enabled-extensions =
                [
                  "appindicatorsupport@rgcjonas.gmail.com"
                  "pano@elhan.io"
                  "quick-settings-tweaks@qwreey"
                  "user-theme@gnome-shell-extensions.gcampax.github.com"
                ]
                ++ optional (cfg.desktop.gnome.extensions.arcmenu) "arcmenu@arcmenu.com"
                ++ optional (cfg.desktop.gnome.extensions.dashToPanel) "dash-to-panel@jderose9.github.com"
                ++ optional (cfg.desktop.gnome.extensions.gsconnect) "gsconnect@andyholmes.github.io";

              favorite-apps = mkIf (cfg.system.user.${user}.desktop.gnome.pinnedApps.shell.enable
              ) cfg.system.user.${user}.desktop.gnome.pinnedApps.shell.list;
            };

            "org/gnome/shell/keybindings" = {
              # Disable clock shortcut
              toggle-message-tray = [ ];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Super>x";
              command = "kitty";
              name = "Kitty";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
              binding = "<Super>e";
              command = "nautilus .";
              name = "Nautilus";
            };

            # Limit app switcher to current workspace
            "org/gnome/shell/app-switcher" = {
              current-workspace-only = true;
            };

            "org/gnome/shell/extensions/clipboard-indicator" = {
              # Remove whitespace before and after the text
              strip-text = true;
              # Open the extension with Super + V
              toggle-menu = [ "<Super>v" ];
            };

            "org/gnome/shell/extensions/dash-to-panel" = mkIf (cfg.desktop.gnome.extensions.dashToPanel) {
              panel-element-positions = ''
                {
                  "0": [
                    {"element":"showAppsButton","visible":false,"position":"stackedTL"},
                    {"element":"activitiesButton","visible":false,"position":"stackedTL"},
                    {"element":"leftBox","visible":true,"position":"stackedTL"},
                    {"element":"taskbar","visible":true,"position":"stackedTL"},
                    {"element":"centerBox","visible":true,"position":"stackedBR"},
                    {"element":"rightBox","visible":true,"position":"stackedBR"},
                    {"element":"dateMenu","visible":true,"position":"stackedBR"},
                    {"element":"systemMenu","visible":true,"position":"stackedBR"},
                    {"element":"desktopButton","visible":true,"position":"stackedBR"}
                  ],
                  "1": [
                    {"element":"showAppsButton","visible":false,"position":"stackedTL"},
                    {"element":"activitiesButton","visible":false,"position":"stackedTL"},
                    {"element":"leftBox","visible":true,"position":"stackedTL"},
                    {"element":"taskbar","visible":true,"position":"stackedTL"},
                    {"element":"centerBox","visible":true,"position":"stackedBR"},
                    {"element":"rightBox","visible":true,"position":"stackedBR"},
                    {"element":"dateMenu","visible":true,"position":"stackedBR"},
                    {"element":"systemMenu","visible":true,"position":"stackedBR"},
                    {"element":"desktopButton","visible":true,"position":"stackedBR"}
                  ]
                }
              ''; # Disable activities button
              panel-sizes = ''{"0":44}'';
              appicon-margin = 4;
              dot-style-focused = "DASHES";
              dot-style-unfocused = "DOTS";
              hide-overview-on-startup = true;
              scroll-icon-action = "NOTHING";
              scroll-panel-action = "NOTHING";
              hot-keys = true;
            };

            "org/gnome/shell/extensions/arcmenu" = mkIf (cfg.desktop.gnome.extensions.arcmenu) {
              distro-icon = 6;
              menu-button-icon = "Distro_Icon"; # Use arch icon
              multi-monitor = true;
              menu-layout = "Windows";
              windows-disable-frequent-apps = true;
              windows-disable-pinned-apps = !cfg.system.user.${user}.desktop.gnome.pinnedApps.arcmenu.enable;
              pinned-app-list = cfg.system.user.${user}.desktop.gnome.pinnedApps.arcmenu.list;
            };

            "org/gnome/shell/extensions/pano" = {
              history-length = 100;
              paste-on-select = false;
              play-audio-on-copy = false;
              send-notification-on-copy = false;
              show-indicator = false;
              wiggle-indicator = false;
            };
          };
        };
      }
    ) users;
}
