{ config, lib, ... }:

lib.mkIf config.system.user.work.enable {
  home-manager.users.${config.system.user.work.username}.home.file = lib.mkIf
    (config.desktop.gnome.enable && config.desktop.gnome.startup-items.enable) {
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
