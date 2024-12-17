{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.icedos.applications;
in
mkIf (cfg.ssh) {
  services.openssh.enable = true;
}
