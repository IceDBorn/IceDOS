{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  session = cfg.applications.steam.session;
in
mkIf (session.enable) {
  jovian = {
    devices.steamdeck = mkIf (cfg.hardware.devices.steamdeck) {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    steam = {
      enable = true;
      autoStart = session.autoStart.enable;
      desktopSession = session.autoStart.desktopSession;
      user = session.user;
    };

    steamos.useSteamOSConfig = cfg.hardware.devices.steamdeck;
  };
}
