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
  users.users.deck.packages =
    with pkgs;
    [
      appimage-run
      bottles
      fragments
      harmony-music
      newsflash
    ]
    ++ emulators
    ++ optional (cfg.applications.falkor) inputs.falkor.packages.${pkgs.system}.default
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;
}
