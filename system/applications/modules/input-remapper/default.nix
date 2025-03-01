{
  config,
  ...
}:

let
  cfg = config.icedos.applications;
in
{
  services.input-remapper.enable = cfg.input-remapper;
}
