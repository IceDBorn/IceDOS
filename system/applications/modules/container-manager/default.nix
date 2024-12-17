{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.system.virtualisation.containerManager;
in
mkIf (cfg.enable) {
  virtualisation.docker.enable = !cfg.usePodman;
  virtualisation.podman.enable = cfg.usePodman;

  # Wrapper around podman to create and start linux containers
  environment.systemPackages = [ pkgs.distrobox ];
}
