{ config, pkgs, lib, ... }:

{
    # Create options for declaring users
    options = {
        main.user = {
            username = lib.mkOption {
                type = lib.types.str;
                default = "main";
            };

            description = lib.mkOption {
                type = lib.types.str;
                default = "Main";
            };
        };

        work.user = {
            username = lib.mkOption {
                type = lib.types.str;
                default = "work";
            };

            description = lib.mkOption {
                type = lib.types.str;
                default = "Work";
            };
        };
    };

    # Set your user
    config.main.user = {
        username = "icedborn";
        description = "IceDBorn";
    };

    imports = [
        # Generated automatically by nixOS
        ./hardware-configuration.nix
        # Packages to install
        ./programs
        # Gnome
        ./desktop
        # CPU, GPU, Drives
        ./hardware
        # Set users
        ./users
        # Bootloader, kernel
        ./boot
        # Startup files
        ./startup
    ];

    # Do not change without checking the docs
    config.system.stateVersion = "22.05";
}
