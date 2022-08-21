{ config, pkgs, ... }:

{
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
    ];

    # Do not change without checking the docs
    system.stateVersion = "22.05";
}
