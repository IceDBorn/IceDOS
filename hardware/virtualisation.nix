{ config, pkgs, ... }:

{
    # Passthrough USB devices
    virtualisation.spiceUSBRedirection.enable = true;
    # A daemon that manages virtual machines
    virtualisation.libvirtd.enable = true;
    # Enable docker
    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
        docker # Containers
        unstable.distrobox # Wrapper around docker to create and start containers
    ];
}
