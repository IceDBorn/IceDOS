# PACKAGES INSTALLED ON MAIN USER
{ config, pkgs, lib, ... }:

lib.mkIf config.main.user.enable {
  users.users.${config.main.user.username}.packages = with pkgs; [
    bottles # Wine manager
    cemu # Wii U Emulator
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
    scanmem # Cheat engine for linux
    steam # Gaming platform
    steamtinkerlaunch # General tweaks for games
    stremio # Straming platform
    sunshine # Remote gaming
    tailscale # VPN with P2P support
    yuzu-early-access # Nintendo Switch emulator
  ];

  services = {
    tailscale.enable = true;
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "sunshine_udev";
      text = ''
        KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/85-sunshine.rules";
    }) # Needed for sunshine input to work
  ];
}
