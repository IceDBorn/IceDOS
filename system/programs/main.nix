### PACKAGES INSTALLED ON MAIN USER ###
{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
	users.users.${config.main.user.username}.packages = with pkgs; lib.mkIf config.main.user.enable [
		bottles # Wine manager
		duckstation # PS1 Emulator
		gamescope # Wayland microcompositor
		godot_4 # Game engine
		heroic # Epic Games Launcher for Linux
		input-remapper # Remap input device controls
		papermc # Minecraft server
		pcsx2 # PS2 Emulator
		ppsspp # PSP Emulator
		prismlauncher # Minecraft launcher
		protontricks # Winetricks for proton prefixes
		rpcs3 # PS3 Emulator
		ryujinx # Switch Emulator
		scanmem # Cheat engine for linux
		steam # Gaming platform
		stremio # Straming platform
		sunshine # Streaming software
	];

	services.input-remapper.enable = config.main.user.enable;
	services.input-remapper.enableUdevRules = config.main.user.enable;
}
