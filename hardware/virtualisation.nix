{ pkgs, config, lib, ... }:

{
  virtualisation = {
    docker.enable = config.hardware.virtualisation.docker;
    libvirtd.enable = config.hardware.virtualisation.libvirtd;
    lxd.enable = config.hardware.virtualisation.lxd;
    spiceUSBRedirection.enable =
      config.hardware.virtualisation.spiceUSBRedirection;
    waydroid.enable = config.hardware.virtualisation.waydroid;
  };

  environment.systemPackages = with pkgs;
    lib.mkIf config.hardware.virtualisation.docker [
      docker # Containers
      distrobox # Wrapper around docker to create and start linux containers
    ];
}
