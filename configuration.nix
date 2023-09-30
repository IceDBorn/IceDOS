{ config, ... }:

{
  imports = [
    # Auto-generated configuration by NixOS
    ./hardware/hardware-configuration.nix
    # Custom configuration
    ./.nix
    ./bootloader
    ./hardware # Enable various hardware capabilities
    ./hardware/amd/radeon.nix
    ./hardware/amd/ryzen.nix
    ./hardware/intel.nix
    ./hardware/laptop.nix
    ./hardware/mounts.nix # Disks to mount on startup
    ./hardware/nvidia.nix
    ./hardware/virtualisation.nix
    ./system/desktop
    ./system/desktop/gnome
    ./system/desktop/hyprwm
    ./system/desktop/hyprwm/hypr
    ./system/desktop/hyprwm/hyprland
    ./system/desktop/steam-session
    ./system/applications
    ./system/users
  ];

  config.system.stateVersion = config.system.state-version;
}
