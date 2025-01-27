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
mkIf (cfg.mysql) {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
