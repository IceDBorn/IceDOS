{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    attrNames
    filter
    foldl'
    mkIf
    ;

  cfg = config.icedos;
  session = cfg.applications.steam.session;

  mapAttrsAndKeys = callback: list: (foldl' (acc: value: acc // (callback value)) { } list);
in
mkIf (cfg.applications.steam.enable) {
  home-manager.users =
    let
      users = filter (user: cfg.system.users.${user}.enable == true) (attrNames cfg.system.users);
    in
    mapAttrsAndKeys (
      user:
      let
        username = cfg.system.users.${user}.username;
      in
      {
        ${username} = {
          home = {
            file = {
              # Enable steam beta
              ".local/share/Steam/package/beta" = mkIf (user != "work" && cfg.applications.steam.beta) {
                text = if (cfg.applications.steam.session.enable) then "steamdeck_publicbeta" else "publicbeta";
              };

              # Enable slow steam downloads workaround
              ".local/share/Steam/steam_dev.cfg" =
                mkIf (user != "work" && cfg.applications.steam.downloadsWorkaround)
                  {
                    text = ''
                      @nClientDownloadEnableHTTP2PlatformLinux 0
                      @fDownloadRateImprovementToAddAnotherConnection 1.0
                    '';
                  };
            };

            packages =
              with pkgs;
              mkIf (!cfg.hardware.devices.steamdeck) [
                steam
                steamtinkerlaunch
              ];
          };
        };
      }
    ) users;

  programs = mkIf (cfg.hardware.devices.steamdeck) {
    steam = {
      enable = true;

      # Needed for steam controller to work on wayland compositors when the steam client is open
      extest.enable = cfg.hardware.devices.steamdeck;
    };
  };
}
