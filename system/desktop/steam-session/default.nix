{ config, lib, pkgs, ... }:

let
  steam-session-logout = pkgs.writeShellScriptBin "steam-session-logout" ''
    pkill -KILL -u $USER
  '';
in lib.mkIf config.desktop-environment.steam.session.enable {
  services.xserver.displayManager.session = [{
    manage = "desktop";
    name = "Steam";
    start =
      "STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W ${config.desktop-environment.steam.session.width} -H ${config.desktop-environment.steam.session.height} -r ${config.desktop-environment.steam.session.refresh-rate} --xwayland-count 2 --adaptive-sync -F fsr -S stretch -e -- steam -gamepadui";
  }];
  environment.systemPackages = [ steam-session-logout ];
}
