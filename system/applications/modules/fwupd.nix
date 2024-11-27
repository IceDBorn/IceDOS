{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.icedos.applications;
in
mkIf (cfg.fwupd) {
  services.fwupd.enable = true;
}
