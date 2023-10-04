{ config, lib, ... }:

lib.mkIf config.system.user.main.enable {
  home-manager.users.${config.system.user.main.username}.home.file = lib.mkIf
    (config.desktop.gnome.enable && config.desktop.gnome.startup-items.enable) {
      # Add signal to startup
      ".config/autostart/signal-desktop.desktop" = {
        text = ''
          [Desktop Entry]
          Exec=signal-desktop
          Icon=signal
          Name=Signal
          StartupWMClass=signal
          Terminal=false
          Type=Application
        '';
      };

      # Add steam to startup
      ".config/autostart/steam.desktop" = {
        text = ''
          [Desktop Entry]
          Exec=steam
          Icon=steam
          Name=Steam
          StartupWMClass=steam
          Terminal=false
          Type=Application
        '';
      };
    };
}
