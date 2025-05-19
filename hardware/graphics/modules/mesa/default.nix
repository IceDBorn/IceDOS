{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
in
mkIf (cfg.hardware.graphics.mesa.unstable) {
  chaotic.mesa-git.enable = true;
}
