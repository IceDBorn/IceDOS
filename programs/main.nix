### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, ... }:

{
	users.users.${config.main.user.username}.packages = with pkgs; [
		duckstation # PS1 Emulator
		godot_4 # Game engine
		heroic # Epic Games Launcher for Linux
		pcsx2 # PS2 Emulator
		ppsspp # PSP Emulator
		protontricks # Winetricks for proton prefixes
		rpcs3 # PS3 Emulator
		ryujinx # Switch Emulator
		scanmem # Cheat engine for linux
		steam # Gaming platform
		bottles # Wine manager
		gamescope # Wayland microcompositor
		papermc # Minecraft server
		prismlauncher # Minecraft launcher
		protonup-ng # Proton ge downloader
		sunshine # Streaming platform
	];
}
