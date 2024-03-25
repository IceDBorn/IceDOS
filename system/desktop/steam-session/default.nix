{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos;
  session = cfg.applications.steam.session;
  steamUser = cfg.system.user.main.username;
  hasAmdGpu = cfg.hardware.gpu.amd;
in {
  jovian = {
    decky-loader = {
      enable = (session.enable && session.decky);
      package = pkgs.decky-loader-prerelease;
    };

    devices.steamdeck = mkIf (cfg.hardware.steamdeck) {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    steam = mkIf (session.enable) {
      enable = true;
      autoStart = session.autoStart.enable;
      desktopSession = session.autoStart.desktopSession;
      user = steamUser;
    };

    hardware.has.amd.gpu = (session.enable && hasAmdGpu);

    steamos.useSteamOSConfig = session.enable;
  };
}
