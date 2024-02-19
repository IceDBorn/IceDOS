{ config, lib, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let username = config.system.user.${user}.username;
    in {
      ${username}.home.file = lib.mkIf
        (config.desktop.gnome.enable && config.desktop.gnome.startupItems) {
          # Add signal to startup
          ".config/autostart/signal-desktop.desktop" =
            lib.mkIf (user != "work") {
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
          ".config/autostart/steam.desktop" = lib.mkIf (user != "work") {
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

          ".config/autostart/slack.desktop" = lib.mkIf (user == "work") {
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
