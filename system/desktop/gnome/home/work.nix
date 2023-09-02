{ config, lib, ... }:

lib.mkIf config.work.user.enable {
  home-manager.users.${config.work.user.username} =
    lib.mkIf config.desktop-environment.gnome.enable {

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
          clock-show-date = config.desktop-environment.gnome.clock-date.enable;
          # Show the battery percentage when on a laptop
          show-battery-percentage = config.laptop.enable;
          # Access the activity overview by moving the mouse to the top-left corner
          enable-hot-corners =
            config.desktop-environment.gnome.hot-corners.enable;
        };

        # Disable lockscreen notifications
        "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };

        "org/gnome/desktop/wm/preferences" = {
          # Disable application is ready notification
          focus-new-windows = "strict";
          # Set number of workspaces
          num-workspaces = 1;
        };

        # Disable mouse acceleration
        "org/gnome/desktop/peripherals/mouse" = { accel-profile = "flat"; };

        # Disable file history
        "org/gnome/desktop/privacy" = { remember-recent-files = false; };

        # Turn off screen
        "org/gnome/desktop/session" = { idle-delay = 270; };

        # Disable screen lock
        "org/gnome/desktop/screensaver" = {
          lock-enabled = true;
          lock-delay = 30;
        };

        # Disable system sounds
        "org/gnome/desktop/sound" = { event-sounds = false; };

        "org/gnome/mutter" = {
          # Enable fractional scaling
          experimental-features = [ "scale-monitor-framebuffer" ];
          # Disable dynamic workspaces
          dynamic-workspaces = false;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          # Disable auto suspend
          sleep-inactive-ac-type = "nothing";
          # Power button shutdown
          power-button-action = "interactive";
        };

        "org/gnome/shell" = {
          # Enable gnome extensions
          disable-user-extensions = false;
          # Set enabled gnome extensions
          enabled-extensions =
            [ "appindicatorsupport@rgcjonas.gmail.com" "pano@elhan.io" ]
            ++ (if (config.desktop-environment.gnome.arcmenu.enable) then
              [ "arcmenu@arcmenu.com" ]
            else
              [ ])
            ++ (if (config.desktop-environment.gnome.caffeine.enable) then
              [ "caffeine@patapon.info" ]
            else
              [ ])
            ++ (if (config.desktop-environment.gnome.dash-to-panel.enable) then
              [ "dash-to-panel@jderose9.github.com" ]
            else
              [ ])
            ++ (if (config.desktop-environment.gnome.gsconnect.enable) then
              [ "gsconnect@andyholmes.github.io" ]
            else
              [ ]);

          favorite-apps =
            lib.mkIf config.desktop-environment.gnome.pinned-apps.enable [
              "webstorm.desktop"
              "slack.desktop"
              "webcord.desktop"
              "firefox.desktop"
            ]; # Set dash to panel pinned apps
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

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Super>x";
            command = "kitty";
            name = "Kitty";
          };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
          {
            binding = "<Super>e";
            command = "nautilus .";
            name = "Nautilus";
          };

        # Limit app switcher to current workspace
        "org/gnome/shell/app-switcher" = { current-workspace-only = true; };

        "org/gnome/shell/extensions/caffeine" =
          lib.mkIf config.desktop-environment.gnome.caffeine.enable {
            # Remember the user choice
            restore-state = true;
            # Disable icon
            show-indicator = false;
            # Disable auto suspend and lock
            user-enabled = true;
            # Disable notifications
            show-notifications = false;
          };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          # Remove whitespace before and after the text
          strip-text = true;
          # Open the extension with Super + V
          toggle-menu = [ "<Super>v" ];
        };

        "org/gnome/shell/extensions/dash-to-panel" =
          lib.mkIf config.desktop-environment.gnome.dash-to-panel.enable {
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

        "org/gnome/shell/extensions/arcmenu" =
          lib.mkIf config.desktop-environment.gnome.arcmenu.enable {
            distro-icon = 6;
            menu-button-icon = "Distro_Icon"; # Use arch icon
            multi-monitor = true;
            menu-layout = "Windows";
            windows-disable-frequent-apps = true;
            windows-disable-pinned-apps =
              !config.desktop-environment.gnome.pinned-apps.enable;
            pinned-app-list =
              lib.mkIf config.desktop-environment.gnome.pinned-apps.enable [
                "VSCodium"
                ""
                "codium.desktop"
                "Spotify"
                ""
                "spotify.desktop"
                "Signal"
                ""
                "signal-desktop.desktop"
                "OBS Studio"
                ""
                "com.obsproject.Studio.desktop"
                "Mullvad VPN"
                ""
                "mullvad-vpn.desktop"
                "GNU Image Manipulation Program"
                ""
                "gimp.desktop"
              ]; # Set arc menu pinned apps
          };
      };
    };
}
