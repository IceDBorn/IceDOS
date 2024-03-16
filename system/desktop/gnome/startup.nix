{ config, lib, ... }:

let
  inherit (lib) attrNames filter foldl' mkIf optional;

  cfg = config.icedos;

  mapAttrsAndKeys = callback: list:
    (foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = filter (user: cfg.system.user.${user}.enable == true)
      (attrNames cfg.system.user);
  in mapAttrsAndKeys (user:
    let username = cfg.system.user.${user}.username;
    in {
      ${username}.home.file =
        mkIf (cfg.desktop.gnome.enable && cfg.desktop.gnome.startupItems) {
          # Add signal to startup
          ".config/autostart/signal-desktop.desktop" = mkIf (user != "work") {
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
          ".config/autostart/steam.desktop" = mkIf (user != "work") {
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

          ".config/autostart/slack.desktop" = mkIf (user == "work") {
            text = ''
              [Desktop Entry]
              Exec=slack --enable-features=WaylandWindowDecorations
              Icon=slack
              Name=Slack
              StartupWMClass=slack
              Terminal=false
              Type=Application
            '';
          };
        };
    }) users;
}
