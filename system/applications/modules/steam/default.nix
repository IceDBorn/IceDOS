{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.steam.enable) {
  home-manager.users = mapAttrs (
    user: _:
    let
      type = cfg.system.users.${user}.type;
    in
    {
      home = {
        file = {
          # Enable steam beta
          ".local/share/Steam/package/beta" = mkIf (type != "work" && cfg.applications.steam.beta) {
            text = if (cfg.applications.steam.session.enable) then "steamdeck_publicbeta" else "publicbeta";
          };

          # Enable slow steam downloads workaround
          ".local/share/Steam/steam_dev.cfg" =
            mkIf (type != "work" && cfg.applications.steam.downloadsWorkaround)
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
    }
  ) cfg.system.users;

  programs = mkIf (cfg.hardware.devices.steamdeck) {
    steam = {
      enable = true;

      # Needed for steam controller to work on wayland compositors when the steam client is open
      extest.enable = cfg.hardware.devices.steamdeck;
    };
  };
}
