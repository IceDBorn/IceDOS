{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  cpu-watcher = import ./cpu-watcher.nix { inherit pkgs config; };
  disk-watcher = import ./disk-watcher.nix { inherit pkgs config; };
  hyprlock-wrapper = import ./hyprlock-wrapper.nix { inherit pkgs; };
  network-watcher = import ./network-watcher.nix { inherit pkgs config; };
  pipewire-watcher = import ./pipewire-watcher.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    cpu-watcher
    disk-watcher
    hyprlock-wrapper
    network-watcher
    pipewire-watcher
    pkgs.hyprlock
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  }) cfg.system.users;
}
