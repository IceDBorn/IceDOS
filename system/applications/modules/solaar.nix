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
mkIf (cfg.solaar) {
  environment.systemPackages = [ pkgs.solaar ];
  services.udev.packages = [ pkgs.logitech-udev-rules ];
}
