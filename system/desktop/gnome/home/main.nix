{ config, lib, ... }:

lib.mkIf config.system.user.main.enable {
  home-manager.users.${config.system.user.main.username} =
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
          clock-show-date = config.desktop.gnome.clock-date.enable;
          # Show the battery percentage when on a laptop
          show-battery-percentage = config.hardware.laptop.enable;
          # Access the activity overview by moving the mouse to the top-left corner
          enable-hot-corners = config.desktop.gnome.hot-corners.enable;
        };

        # Disable lockscreen notifications
        "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };

        "org/gnome/desktop/wm/preferences" = {
          # Disable application is ready notification
          focus-new-windows = "strict";
          num-workspaces = config.desktop.gnome.workspaces.max-workspaces;
        };

        # Disable mouse acceleration
        "org/gnome/desktop/peripherals/mouse" = { accel-profile = "flat"; };

        # Disable file history
        "org/gnome/desktop/privacy" = { remember-recent-files = false; };

        # Disable screen lock
        "org/gnome/desktop/screensaver" = { lock-enabled = false; };

        # Disable system sounds
        "org/gnome/desktop/sound" = { event-sounds = false; };

        "org/gnome/mutter" = {
          # Enable window snapping to the edges of the screen
          edge-tiling = true;
          # Enable fractional scaling
          experimental-features = [ "scale-monitor-framebuffer" ];
          dynamic-workspaces =
            config.desktop.gnome.workspaces.dynamic-workspaces.enable;
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
          ] ++ lib.optional config.desktop.gnome.arcmenu.enable
            "arcmenu@arcmenu.com"
            ++ lib.optional config.desktop.gnome.caffeine.enable
            "caffeine@patapon.info"
            ++ lib.optional config.desktop.gnome.dash-to-panel.enable
            "dash-to-panel@jderose9.github.com"
            ++ lib.optional config.desktop.gnome.gsconnect.enable
            "gsconnect@andyholmes.github.io";

          favorite-apps = lib.mkIf config.desktop.gnome.pinned-apps.enable [
            "webstorm.desktop"
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
          lib.mkIf config.desktop.gnome.caffeine.enable {
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
          lib.mkIf config.desktop.gnome.dash-to-panel.enable {
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
          lib.mkIf config.desktop.gnome.arcmenu.enable {
            distro-icon = 6;
            menu-button-icon = "Distro_Icon"; # Use arch icon
            multi-monitor = true;
            menu-layout = "Windows";
            windows-disable-frequent-apps = true;
            windows-disable-pinned-apps =
              !config.desktop.gnome.pinned-apps.enable;
            pinned-app-list = lib.mkIf config.desktop.gnome.pinned-apps.enable [
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
