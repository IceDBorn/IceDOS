{ config, lib, ... }:

lib.mkIf config.work.user.enable {
  home-manager.users.${config.work.user.username}.home.file = lib.mkIf
    (config.desktop-environment.gnome.enable
      && config.desktop-environment.gnome.startup-items.enable) {
        ".config/autostart/slack.desktop" = {
          text = ''
            [Desktop Entry]
            Exec=slack --enable-features=WaylandWindowDecorations
            Icon=slack
            Name=Slack
            StartupWMClass=slack
            Terminal=false
            Type=Application
          '';
          recursive = true;
        }; # Add signal to startup
      };
}
