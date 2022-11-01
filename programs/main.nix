### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
    users.users.${config.main.user.username}.packages = with pkgs; [
        (callPackage ./self-built/protonup-ng.nix { buildPythonPackage = pkgs.python3Packages.buildPythonPackage; configparser = pkgs.python3Packages.configparser; fetchPypi = pkgs.python3Packages.fetchPypi; pythonOlder = pkgs.python3Packages.pythonOlder; requests = pkgs.python3Packages.requests; }) # Proton GE downloader
        duckstation # PS1 Emulator
        heroic # Epic Games Launcher for Linux
        pcsx2 # PS2 Emulator
        ppsspp # PSP Emulator
        protontricks # Winetricks for proton prefixes
        rpcs3 # PS3 Emulator
        ryujinx # Switch Emulator
        scanmem # Cheat engine for linux
        steam # Gaming platform
        unstable.bottles # Wine manager
        unstable.gamescope # Wayland microcompositor
        unstable.papermc # Minecraft server
        unstable.prismlauncher # Minecraft launcher
        unstable.sunshine # Streaming platform
    ];
}
