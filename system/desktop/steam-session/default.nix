{ config, lib, ... }:

lib.mkIf config.applications.steam.session.enable {
  jovian = {
    decky-loader.enable = true;

    devices.steamdeck = lib.mkIf config.applications.steam.session.steamdeck {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    steam = {
      enable = true;
      autoStart = config.applications.steam.session.autoStart.enable;
      desktopSession =
        config.applications.steam.session.autoStart.desktopSession;
      user = config.system.user.main.username;
    };
  };
}
