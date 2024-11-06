{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  hyprlock-wrapper = import ./hyprlock-wrapper.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    hyprlock-wrapper
    pkgs.hyprlock
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  }) cfg.system.users;
}
