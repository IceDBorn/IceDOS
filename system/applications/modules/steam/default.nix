{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;
  steamdeck = cfg.hardware.devices.steamdeck;
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

        packages = mkIf (!steamdeck && !cfg.applications.gamescope) [ pkgs.steam ];
      };
    }
  ) cfg.system.users;

  programs.steam = mkIf (steamdeck) {
    enable = true;
    extest.enable = true;
  };
}
