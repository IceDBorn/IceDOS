{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) optional;
  cfg = config.icedos;
in
{
  users.users.icedborn.packages =
    with pkgs;
    [
      # cemu
      # duckstation
      # heroic
      # pcsx2
      # ppsspp
      # prismlauncher
      # rpcs3
      blanket
      bottles
      inputs.falkor.packages.${pkgs.system}.default
      obs-studio
      protontricks
      stremio
    ]
    ++ optional (cfg.applications.falkor) inputs.falkor.packages.${pkgs.system}.default
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;
}
