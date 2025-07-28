{
  config,
  ...
}:

let
  cfg = config.icedos;
  graphics = cfg.hardware.graphics;
in
{
  chaotic.mesa-git.enable = (graphics.enable && graphics.mesa.unstable);
}
