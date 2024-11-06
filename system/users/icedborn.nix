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
    heroic # Cross-platform Epic Games Launcher
    ludusavi # Game saves cloud backup with Nextcloud
    prismlauncher # Minecraft launcher
    protontricks # Winetricks for proton prefixes
    rclone # Sync to and from nextcloud
  ];
in
{
  users.users.icedborn.packages =
    with pkgs;
    [
      bottles # Wine manager
      godot_4 # Game engine
      stremio # Media streaming platform
    ]
    ++ emulators
    ++ gaming;
}
