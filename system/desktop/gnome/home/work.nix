{ config, lib, ... }:

lib.mkIf config.system.user.work.enable {
  home-manager.users.${config.system.user.work.username} =
    lib.mkIf config.desktop.gnome.enable {

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
          clock-show-date = config.desktop.gnome.clockDate;
          clock-show-weekday = config.desktop.gnome.clockWeekday;
          # Show the battery percentage when on a laptop
          show-battery-percentage = config.hardware.laptop.enable;
          # Access the activity overview by moving the mouse to the top-left corner
          enable-hot-corners = config.desktop.gnome.hotCorners;
        };

        # Disable lockscreen notifications
        "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };

        "org/gnome/desktop/wm/preferences" = {
          # Buttons to show in titlebars
          button-layout = config.desktop.gnome.titlebarLayout;
          # Disable application is ready notification
          focus-new-windows = "strict";
          num-workspaces = config.desktop.gnome.workspaces.maxWorkspaces;
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
          # Enable window snapping to the edges of the screen
          edge-tiling = true;
          # Enable fractional scaling
          experimental-features = [ "scale-monitor-framebuffer" ];
          dynamic-workspaces =
            config.desktop.gnome.workspaces.dynamicWorkspaces;
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
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "pano@elhan.io"
            "quick-settings-tweaks@qwreey"
          ] ++ lib.optional config.desktop.gnome.arcmenu
            "arcmenu@arcmenu.com"
            ++ lib.optional config.desktop.gnome.caffeine
            "caffeine@patapon.info"
            ++ lib.optional config.desktop.gnome.dashToPanel
            "dash-to-panel@jderose9.github.com"
            ++ lib.optional config.desktop.gnome.gsconnect
            "gsconnect@andyholmes.github.io";

          favorite-apps = lib.mkIf config.desktop.gnome.pinnedApps [
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
          lib.mkIf config.desktop.gnome.caffeine {
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
          lib.mkIf config.desktop.gnome.dashToPanel {
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
          lib.mkIf config.desktop.gnome.arcmenu {
            distro-icon = 6;
            menu-button-icon = "Distro_Icon"; # Use arch icon
            multi-monitor = true;
            menu-layout = "Windows";
            windows-disable-frequent-apps = true;
            windows-disable-pinned-apps =
              !config.desktop.gnome.pinnedApps;
            pinned-app-list = lib.mkIf config.desktop.gnome.pinnedApps [
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
