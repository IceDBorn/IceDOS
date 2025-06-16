{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  session = cfg.applications.steam.session;
in
mkIf (session.enable) {
  jovian = {
    devices.steamdeck = mkIf (cfg.hardware.devices.steamdeck && !cfg.internals.isFirstBuild) {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    hardware.has.amd.gpu = cfg.hardware.graphics.amd.enable;

    steam = {
      enable = true;
      autoStart = session.autoStart.enable;
      desktopSession = session.autoStart.desktopSession;
      updater.splash = if (cfg.hardware.devices.steamdeck) then "jovian" else "vendor";
      user = session.user;
    };

    steamos.useSteamOSConfig = true;
  };
}
