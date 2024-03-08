# PACKAGES INSTALLED ON MAIN USER
{ config, pkgs, lib, ... }:

let
  install-proton-ge = import modules/wine-build-updater.nix {
    inherit pkgs;
    name = "proton-ge";
    buildPath = "${pkgs.proton-ge-custom}/bin";
    installPath =
      "/home/${config.system.user.main.username}/.local/share/Steam/compatibilitytools.d";
    message = "proton ge";
    type = "Proton";
  };

  install-wine-ge = import modules/wine-build-updater.nix {
    inherit pkgs;
    name = "wine-ge";
    buildPath = "${pkgs.wine-ge}/bin";
    installPath =
      "/home/${config.system.user.main.username}/.local/share/bottles/runners";
    message = "wine ge";
    type = "Wine";
  };

  steam-library-patcher = import modules/steam-library-patcher.nix {
    inherit pkgs;
    steamPath =
      "/home/${config.system.user.main.username}/.local/share/Steam/steamui/css/";
  };

  # Update the system configuration
  update = import modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
    stash = config.system.update.stash;
  };

  emulators = with pkgs; [
    cemu # Wii U Emulator
    duckstation # PS1 Emulator
    pcsx2 # PS2 Emulator
    ppsspp # PSP Emulator
    rpcs3 # PS3 Emulator
  ];

  gaming = with pkgs; [
    heroic # Epic Games Launcher for Linux
    papermc # Minecraft server
    prismlauncher # Minecraft launcher
    protontricks # Winetricks for proton prefixes
    steam # Gaming platform
    steamtinkerlaunch # General tweaks for games
  ];

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  shellScripts = [ update install-wine-ge install-proton-ge ]
    ++ lib.optional config.applications.steam.adwaitaForSteam.enable
    steam-library-patcher;
  adwaitaForSteam = config.applications.steam.adwaitaForSteam;
in lib.mkIf config.system.user.main.enable {
  users.users.${config.system.user.main.username}.packages = with pkgs;
    [
      bottles # Wine manager
      godot_4 # Game engine
      input-remapper # Remap input device controls
      scanmem # Cheat engine for linux
      stremio # Straming platform
    ] ++ emulators ++ gaming ++ myPackages ++ shellScripts;

  # Wayland microcompositor
  programs.gamescope = lib.mkIf (!config.applications.steam.session.enable) {
    enable = true;
    capSysNice = true;
  };

  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
  };

  nerivations.adwaita-for-steam.extras = adwaitaForSteam.extras;
}
