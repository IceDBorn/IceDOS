### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
    imports = [ ./protonup-ng.nix ]; # Proton ge downloader

    users.users.${config.main.user.username}.packages = with pkgs; [
        bottles # Wine prefix manager
        duckstation # PS1 Emulator
        gamemode # Optimizations for gaming
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
        unstable.android-studio # IDE for Android apps
        unstable.gamescope # Wayland microcompositor
    ];
}
