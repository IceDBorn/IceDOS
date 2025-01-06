{ config, ... }:

let
  cfg = config.icedos.system;
in
{
  imports = [
    ./hardware # Enable various hardware capabilities
    ./hardware/amd/radeon.nix
    ./hardware/amd/ryzen.nix
    ./hardware/bluetooth.nix
    ./hardware/bootloader.nix
    ./hardware/intel.nix
    ./hardware/mounts.nix # Disks to mount on startup
    ./hardware/nvidia.nix
    ./hardware/server.nix
    ./options.nix
    ./system/applications
    ./system/users
  ];

  config.system.stateVersion = cfg.version;
}
