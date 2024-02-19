{ config, lib, ... }:

let
  cfg = config.applications.steam.session;
  steamUser = config.system.user.main.username;
  amdGpu = config.hardware.gpu.amd.enable;
in {
  # Unlock password using steam deck controller
  imports = [ modules/deckbd-wrapper.nix ];

  jovian = {
    decky-loader.enable = (cfg.enable && cfg.decky);

    devices.steamdeck = lib.mkIf (cfg.enable && cfg.steamdeck) {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    steam = lib.mkIf cfg.enable {
      enable = true;
      autoStart = cfg.autoStart.enable;
      desktopSession = cfg.autoStart.desktopSession;
      user = steamUser;
    };

    hardware.has.amd.gpu = (cfg.enable && amdGpu);
    steamos.useSteamOSConfig = cfg.enable;
  };
}
