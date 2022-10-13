### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
    users.users.${config.main.user.username}.packages = with pkgs; [
        duckstation # PS1 Emulator
        godot # Game engine
        heroic # Epic Games Launcher for Linux
        mangohud # A metric overlay
        nvtop # GPU monitoring tool
        pcsx2 # PS2 Emulator
        polymc # Minecraft launcher
        ppsspp # PSP Emulator
        protontricks # Winetricks for proton prefixes
        rpcs3 # PS3 Emulator
        ryujinx # Switch Emulator
        scanmem # Cheat engine for linux
        steam # Gaming platform
        unstable.gamescope # Wayland microcompositor
        unstable.papermc # Minecraft server
    ];
}
