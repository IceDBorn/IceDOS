{ config, lib, ... }:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
{
  home-manager.users =
    let
      users = attrNames cfg.system.users;
    in
    mapAttrsAndKeys (
      user:
      let
        type = cfg.system.users.${user}.type;
      in
      {
        ${user}.home.file = mkIf (cfg.desktop.gnome.enable && cfg.desktop.gnome.startupItems) {
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
    ) users;
}
