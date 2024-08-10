{
  config,
  lib,
  pkgs,
  ...
}:

let
  nix-gc = import ./nix-gc.nix { inherit config lib pkgs; };
  cfg = config.icedos.system.generations.garbageCollect;
in
{
  environment.systemPackages = [ nix-gc ];

  nix.gc = {
    automatic = cfg.automatic;
    dates = "${cfg.interval}";
  };
}
