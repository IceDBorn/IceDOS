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
mkIf (cfg.clamav) {
  environment.systemPackages = [ pkgs.clamav ];

  services.clamav.updater.enable = true;
}
