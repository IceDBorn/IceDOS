{ config, ... }:

let
  cfg = config.icedos.system;
in
{
  imports = [
    # Auto-generated configuration by NixOS
    ./hardware/nixos/hardware-configuration.nix
    ./hardware/nixos/extras.nix

    # Custom configuration
    ./hardware # Enable various hardware capabilities
    ./hardware/amd/radeon.nix
    ./hardware/amd/ryzen.nix
    ./hardware/bootloader.nix
    ./hardware/deckbd-wrapper.nix
    ./hardware/intel.nix
    ./hardware/mounts.nix # Disks to mount on startup
    ./hardware/nvidia.nix
    ./hardware/server.nix
    ./options.nix
    ./system/applications
    ./system/desktop
    ./system/desktop/gnome
    ./system/users.nix
  ];

  config.system.stateVersion = cfg.version;
}
