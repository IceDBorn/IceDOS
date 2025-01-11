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

  emulators = [
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
      adwsteamgtk
      appimage-run
      blanket
      bottles
      fragments
      ghex
      gimp
      newsflash
      obs-studio
      protontricks
      protonup-qt
      warp
      wine
      winetricks
    ]
    ++ emulators
    ++ optional (cfg.applications.falkor) inputs.falkor.packages.${pkgs.system}.default
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;
}
