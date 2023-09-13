# PACKAGES INSTALLED ON MAIN USER
{ config, pkgs, lib, ... }:

let
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
in lib.mkIf config.system.user.main.enable {
  users.users.${config.system.user.main.username}.packages = with pkgs;
    [
      bottles # Wine manager
      godot_4 # Game engine
      input-remapper # Remap input device controls
      scanmem # Cheat engine for linux
      stremio # Straming platform
      tailscale # VPN with P2P support
    ] ++ emulators ++ gaming;

  # Wayland microcompositor
  programs.gamescope = lib.mkIf (!config.applications.steam.session.enable) {
    enable = true;
    capSysNice = true;
  };

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
