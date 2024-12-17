{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    ;

  cfg = config.icedos;
in
mkIf (cfg.applications.brave) {
  environment.systemPackages = [ pkgs.brave ];
}
