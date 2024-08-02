{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.virtualisation;
in
mkIf (cfg.podman) {
  virtualisation.podman.enable = true;

  # Wrapper around podman to create and start linux containers
  environment.systemPackages = [ pkgs.distrobox ];
}
