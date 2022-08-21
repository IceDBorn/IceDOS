{ config, pkgs, ... }:

{
    imports = [
        # Disks to mount on startup
        ./mounts.nix
        # Ryzen cpu voltage and clock control
        ./ryzen.nix
        # Nvidia drivers, configuration and power limit
        ./nvidia.nix
    ];

    hardware = {
        opengl = {
            enable = true;
            # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
            driSupport32Bit = true;
        };
    };
}