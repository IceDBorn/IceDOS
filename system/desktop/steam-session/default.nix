{ config, lib, ... }:

let
  cfg = config.applications.steam.session;
  steamUser = config.system.user.main.username;
in {
  # Unlock password using steam deck controller
  imports = [ modules/deckbd-wrapper.nix ];

  jovian = {
    decky-loader.enable = cfg.decky;

    devices.steamdeck = lib.mkIf cfg.steamdeck {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    steam = {
      enable = true;
      autoStart = cfg.autoStart.enable;
      desktopSession = cfg.autoStart.desktopSession;
      user = steamUser;
    };
  };
}
