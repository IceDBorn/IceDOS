{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;
  package = [ pkgs.gamescope ];
  ifSteam = deck: cfg.applications.steam.enable && deck;
in
mkIf (cfg.applications.gamescope) {
  environment.systemPackages = package;
  programs.steam.extraPackages = mkIf (ifSteam (cfg.hardware.devices.steamdeck)) package;

  home-manager.users = mapAttrs (user: _: {
    home.packages =
      mkIf (ifSteam (!cfg.hardware.devices.steamdeck) && !cfg.applications.proton-launch)
        [
          (pkgs.steam.override { extraPkgs = pkgs: package; })
        ];
  }) cfg.system.users;
}
