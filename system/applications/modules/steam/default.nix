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
  applications = cfg.applications;
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
          ".local/share/Steam/package/beta" = mkIf (type != "work" && applications.steam.beta) {
            text = if (applications.steam.session.enable) then "steamdeck_publicbeta" else "publicbeta";
          };

          # Enable slow steam downloads workaround
          ".local/share/Steam/steam_dev.cfg" =
            mkIf (type != "work" && applications.steam.downloadsWorkaround)
              {
                text = ''
                  @nClientDownloadEnableHTTP2PlatformLinux 0
                '';
              };
        };

        packages = mkIf (!steamdeck && !applications.gamescope && !applications.proton-launch) [
          pkgs.steam
        ];
      };
    }
  ) cfg.system.users;

  programs.steam = mkIf (steamdeck) {
    enable = true;
    extest.enable = true;
  };
}
