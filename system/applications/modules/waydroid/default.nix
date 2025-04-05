{
  config,
  ...
}:

let
  cfg = config.icedos.system.virtualisation;
in
{
  virtualisation.waydroid.enable = cfg.waydroid;
}
