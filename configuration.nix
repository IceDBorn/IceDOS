{ config, pkgs, lib, ... }:
let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
    # Create options for declaring users
    options = {
        main-user = {
            username = lib.mkOption {
                type = lib.types.str;
                default = "main";
            };

            description = lib.mkOption {
                type = lib.types.str;
                default = "Main";
            };
        };

        work-user = {
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
    config.main-user = {
        username = "icedborn";
        description = "IceDBorn";
    };

    imports = [
        # Import home manager
        (import "${home-manager}/nixos")
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
    ];

    # Do not change without checking the docs
    config.system.stateVersion = "22.05";
}
