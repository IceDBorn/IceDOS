{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.hardware.virtualisation;
in
{
  virtualisation = {
    waydroid.enable = cfg.waydroid;
  };
}
