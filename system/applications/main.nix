# PACKAGES INSTALLED ON MAIN USER
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkIf optional;

  cfg = config.icedos;
  username = cfg.system.user.main.username;

  install-proton-ge = import modules/wine-build-updater.nix {
    inherit pkgs;
    name = "proton-ge";
    buildPath = "${pkgs.proton-ge-custom}/bin";
    installPath = "/home/${username}/.local/share/Steam/compatibilitytools.d";
    message = "proton ge";
    type = "Proton";
  };

  install-wine-ge = import modules/wine-build-updater.nix {
    inherit pkgs;
    name = "wine-ge";
    buildPath = "${pkgs.wine-ge}/bin";
    installPath = "/home/${username}/.local/share/bottles/runners";
    message = "wine ge";
    type = "Wine";
  };

  # Update the system configuration
  update = import modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
  };

  emulators =
    with pkgs;
    [
      duckstation # PS1
      pcsx2 # PS2
      ppsspp # PSP
      rpcs3 # PS3
    ]
    ++ optional (cfg.applications.emulators.switch) inputs.switch-emulators.packages.${pkgs.system}.suyu
    ++ optional (cfg.applications.emulators.wiiu) cemu;

  gaming = with pkgs; [
    heroic # Epic Games Launcher for Linux
    papermc # Minecraft server
    prismlauncher # Minecraft launcher
    protontricks # Winetricks for proton prefixes
    steamtinkerlaunch # General tweaks for games
  ];

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  shellScripts = [
    update
    install-wine-ge
    install-proton-ge
  ];
in
mkIf (cfg.system.user.main.enable) {
  users.users.${username}.packages =
    with pkgs;
    [
      bottles # Wine manager
      godot_4 # Game engine
      input-remapper # Remap input device controls
      ludusavi # Cloud backup with Nextcloud
      rclone # Sync to and from nextcloud
      scanmem # Cheat engine for linux
      stremio # Straming platform
    ]
    ++ emulators
    ++ gaming
    ++ myPackages
    ++ shellScripts;

  # Wayland microcompositor
  programs = {
    gamescope = mkIf (!cfg.applications.steam.session.enable) {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;

      # Needed for steam controller to work on wayland compositors when the steam client is open
      extest.enable = cfg.hardware.devices.steamdeck;
    };
  };

  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
  };
}
