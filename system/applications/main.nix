# PACKAGES INSTALLED ON MAIN USER
{ config, pkgs, lib, ... }:

let
  stashLock = if (config.system.update.stash-flake-lock) then "1" else "0";

  # Rebuild the system configuration
  update = pkgs.writeShellScriptBin "update" "rebuild 1 ${stashLock} 1 1";

  emulators = with pkgs; [
    cemu # Wii U Emulator
    duckstation # PS1 Emulator
    pcsx2 # PS2 Emulator
    ppsspp # PSP Emulator
    rpcs3 # PS3 Emulator
    yuzu-early-access # Nintendo Switch emulator
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

  shellScripts = [ update ];
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
}
