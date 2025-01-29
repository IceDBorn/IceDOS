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
mkIf (cfg.protonvpn) {
  environment.systemPackages = [ pkgs.protonvpn-gui ];
}
