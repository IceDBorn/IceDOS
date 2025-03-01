{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos.system.virtualisation.containerManager;
in
mkIf (cfg.enable) {
  environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.docker.enable = !cfg.usePodman;
  virtualisation.podman.enable = cfg.usePodman;

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
