{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) optional;
  cfg = config.icedos;

  emulators = with pkgs; [
    # cemu
    # duckstation
    # heroic
    # pcsx2
    # ppsspp
    # prismlauncher
    # rpcs3
  ];
in
{
  users.users.icedborn.packages =
    with pkgs;
    [
      appimage-run
      blanket
      bottles
      fragments
      gimp
      harmony-music
      newsflash
      warp
    ]
    ++ emulators
    ++ optional (cfg.applications.falkor) inputs.falkor.packages.${pkgs.system}.default
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;
}
