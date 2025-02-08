{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        # Use different keyboard language for each window
        per-window = true;
      };

      "org/gnome/desktop/interface" = {
        accent-color = cfg.desktop.gnome.accentColor;
        color-scheme = "prefer-dark";
        clock-show-seconds = true;
        clock-show-date = cfg.desktop.gnome.clock.date;
        clock-show-weekday = cfg.desktop.gnome.clock.weekday;
        show-battery-percentage = cfg.hardware.devices.laptop;
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
          if (cfg.system.users.${user}.desktop.idle.disableMonitors.enable) then
            builtins.toString (cfg.system.users.${user}.desktop.idle.disableMonitors.seconds)
          else
            0;
      };

      # Set screen lock
      "org/gnome/desktop/screensaver" = {
        lock-enabled = cfg.system.users.${user}.desktop.idle.lock.enable;
        lock-delay = builtins.toString (cfg.system.users.${user}.desktop.idle.lock.seconds);
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
          if (cfg.system.users.${user}.desktop.idle.suspend.enable) then "suspend" else "nothing";
        # Auto suspend timeout
        sleep-inactive-ac-timeout = builtins.toString (
          cfg.system.users.${user}.desktop.idle.suspend.seconds
        );
        # Power button shutdown
        power-button-action = cfg.desktop.gnome.powerButtonAction;
      };

      "org/gnome/shell" = {
        # Enable gnome extensions
        disable-user-extensions = false;
        # Set enabled gnome extensions
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "quick-settings-tweaks@qwreey"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];

        favorite-apps = mkIf (cfg.system.users.${user}.desktop.gnome.pinnedApps.shell.enable
        ) cfg.system.users.${user}.desktop.gnome.pinnedApps.shell.list;
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
    };
  }) cfg.system.users;
}
