{ config, lib, ... }:

lib.mkIf config.desktop-environment.steam.session.enable {
  services.xserver.displayManager.session = [{
    manage = "desktop";
    name = "Steam";
    start =
      "STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W ${config.desktop-environment.steam.session.width} -H ${config.desktop-environment.steam.session.height} -r ${config.desktop-environment.steam.session.refresh-rate} --xwayland-count 2 --adaptive-sync --default-touch-mode 4 --hide-cursor-delay 3000 --fade-out-duration 200 --cursor \${HOME}/.icons/default/cursors/default  -F fsr -S stretch -e -- steam -gamepadui -steamdeck";
  }];
}
