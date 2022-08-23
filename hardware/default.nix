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

    # Set memory limits
    security.pam.loginLimits =
    [
        {
            domain = "*";
            type = "hard";
            item = "memlock";
            value = "2147483648";
        }

        {
            domain = "*";
            type = "soft";
            item = "memlock";
            value = "2147483648";
        }
    ];

    boot.kernelModules = [
        "v4l2loopback" # Virtual camera for OBS
        "xpadneo" # XBOX Gamepad bluetooth driver
    ];
}
