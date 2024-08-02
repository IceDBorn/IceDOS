{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.hardware.virtualisation;
in
{
  virtualisation = {
    docker.enable = cfg.docker;
    lxd.enable = cfg.lxd;
    waydroid.enable = cfg.waydroid;
  };

  environment.systemPackages =
    with pkgs;
    mkIf (cfg.docker) [
      docker # Containers
      distrobox # Wrapper around docker to create and start linux containers
    ];
}
