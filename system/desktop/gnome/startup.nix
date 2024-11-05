{ config, lib, ... }:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (
    user: _:
    let
      type = cfg.system.users.${user}.type;
    in
    {
      home.file = mkIf (cfg.desktop.gnome.startupItems) {
        # Add signal to startup
        ".config/autostart/signal-desktop.desktop" = mkIf (type != "work") {
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
        ".config/autostart/steam.desktop" = mkIf (type != "work") {
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

        ".config/autostart/slack.desktop" = mkIf (type == "work") {
          text = ''
            [Desktop Entry]
            Exec=slack
            Icon=slack
            Name=Slack
            StartupWMClass=slack
            Terminal=false
            Type=Application
          '';
        };
      };
    }
  ) cfg.system.users;
}
