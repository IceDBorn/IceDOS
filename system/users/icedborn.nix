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

  emulators =
    with pkgs;
    [
      # cemu # Wiuu
      # duckstation # PS1
      # pcsx2 # PS2
      # ppsspp # PSP
      # rpcs3 # PS3
    ]
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;

  gaming = with pkgs; [
    # heroic # Cross-platform Epic Games Launcher
    # prismlauncher # Minecraft launcher
    protontricks # Winetricks for proton prefixes
  ];
in
{
  users.users.icedborn.packages =
    with pkgs;
    [
      blanket
      bottles
      stremio
    ]
    ++ emulators
    ++ gaming;
}
