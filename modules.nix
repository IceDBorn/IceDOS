{ config, ... }:

let cfg = config.icedos.system;
in {
  imports = [
    # Auto-generated configuration by NixOS
    ./hardware/nixos/hardware-configuration.nix
    ./hardware/nixos/extras.nix

    # Custom configuration
    ./.nix
    ./hardware # Enable various hardware capabilities
    ./hardware/amd/radeon.nix
    ./hardware/amd/ryzen.nix
    ./hardware/bootloader.nix
    ./hardware/deckbd-wrapper.nix
    ./hardware/intel.nix
    ./hardware/laptop.nix
    ./hardware/mounts.nix # Disks to mount on startup
    ./hardware/nvidia.nix
    ./hardware/virtualisation.nix
    ./system/applications
    ./system/desktop
    ./system/desktop/gnome
    ./system/desktop/hyprland
    ./system/desktop/steam-session
    ./system/users.nix
  ];

  config.system.stateVersion = cfg.version;
}
