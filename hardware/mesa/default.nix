{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
in
mkIf (cfg.hardware.drivers.mesa.unstable) {
  chaotic.mesa-git.enable = true;
}
