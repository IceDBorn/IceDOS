{ lib, config, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos;
  session = cfg.applications.steam.session;
  steamUser = cfg.system.user.main.username;
  hasAmdGpu = cfg.hardware.gpus.amd;
in
{
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
      user = steamUser;
    };

    hardware.has.amd.gpu = hasAmdGpu;

    steamos.useSteamOSConfig = true;
  };
}
