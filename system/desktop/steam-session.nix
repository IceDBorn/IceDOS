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
mkIf (cfg.applications.steam.enable && session.enable) {
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
      user = cfg.system.users.main.username;
    };

    hardware.has.amd.gpu = cfg.hardware.gpus.amd;

    steamos.useSteamOSConfig = true;
  };
}
