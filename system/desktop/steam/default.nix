{ config, lib, pkgs, ... }:

let
  steam-logout = pkgs.writeShellScriptBin "steam-logout" ''
    killall gamescope-wl
  '';
in lib.mkIf config.desktop-environment.steam.enable {
  services.xserver.displayManager.session = [{
    manage = "desktop";
    name = "Steam";
    start =
      "STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W ${config.desktop-environment.steam.width} -H ${config.desktop-environment.steam.height} -r ${config.desktop-environment.steam.refresh-rate} --xwayland-count 2 --adaptive-sync -F fsr -S stretch -e -- steam -gamepadui";
  }];
  environment.systemPackages = [ steam-logout ];
}
