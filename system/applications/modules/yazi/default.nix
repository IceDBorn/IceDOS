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
mkIf (cfg.yazi) {
  environment.systemPackages = [ pkgs.yazi ];
}
