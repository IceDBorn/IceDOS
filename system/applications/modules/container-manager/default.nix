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
  environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.docker.enable = !cfg.usePodman;
  virtualisation.podman.enable = cfg.usePodman;
}
