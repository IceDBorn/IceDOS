# PACKAGES INSTALLED ON MAIN USER
{ config, pkgs, lib, ... }:

let
  configuration-location = builtins.readFile ../../.configuration-location;

  update = pkgs.writeShellScriptBin "update" ''
    stashLock=$(git stash push -m "flake.lock@$(date +%A-%d-%B-%T)" flake.lock > /dev/null)
      # Navigate to configuration directory
      cd ${configuration-location} 2> /dev/null || (echo 'Configuration path is invalid. Run build.sh manually to update the path!' && exit 2)

      # Stash the flake lock file
      if [ $(git stash list | wc -l) -eq 0 ]; then
        $stashLock
      else
        [ -n "$(git diff stash flake.lock)" ] && $stashLock
      fi

      nix flake update && bash build.sh
      apx --aur upgrade
      bash ~/.config/zsh/proton-ge-updater.sh
      bash ~/.config/zsh/steam-library-patcher.sh
      bash ~/.config/zsh/update-codium-extensions.sh
  '';

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
      update # Update the system configuration
    ] ++ emulators ++ gaming;

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
