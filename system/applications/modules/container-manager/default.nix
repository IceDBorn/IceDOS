{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos.system;
in
mkIf (cfg.virtualisation.containerManager.enable) {
  environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.docker.enable = !cfg.virtualisation.containerManager.usePodman;
  virtualisation.podman.enable = cfg.virtualisation.containerManager.usePodman;

  users.users = mapAttrs (user: _: {
    extraGroups =
      mkIf
        (
          !cfg.virtualisation.containerManager.usePodman
          && !cfg.virtualisation.containerManager.requireSudoForDocker
        )
        [
          "docker"
        ];
  }) cfg.users;
}
