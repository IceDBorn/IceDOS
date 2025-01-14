{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.system.virtualisation;
in
{
  virtualisation.waydroid.enable = cfg.waydroid;
}
