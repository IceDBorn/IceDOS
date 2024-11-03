{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.icedos.applications;
in
mkIf (cfg.pitivi) {
  environment.systemPackages = [ pkgs.pitivi ];
}
