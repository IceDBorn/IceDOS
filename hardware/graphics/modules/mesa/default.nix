{
  config,
  ...
}:

let
  cfg = config.icedos;
in
{
  chaotic.mesa-git.enable = cfg.hardware.graphics.mesa.unstable;
}
