### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
    imports = [ ./protonup-ng.nix ]; # Proton ge downloader

    users.users.${config.main.user.username}.packages = with pkgs; [
        android-studio # IDE for Android apps
        bottles # Wine prefix manager
        duckstation # PS1 Emulator
        gamemode # Optimizations for gaming
        godot # Game engine
        gnome.gnome-boxes # VM manager
        heroic # Epic Games Launcher for Linux
        mangohud # A metric overlay
        pcsx2 # PS2 Emulator
        ppsspp # PSP Emulator
        protontricks # Winetricks for proton prefixes
        rpcs3 # PS3 Emulator
        ryujinx # Switch Emulator
        scanmem # Cheat engine for linux
        steam # Gaming platform
    ];
}