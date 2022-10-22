### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
    users.users.${config.main.user.username}.packages = with pkgs; [
        duckstation # PS1 Emulator
        godot # Game engine
        heroic # Epic Games Launcher for Linux
        mangohud # A metric overlay
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
    ];
}
