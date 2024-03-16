{ pkgs, config, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos.hardware.virtualisation;
in {
  virtualisation = {
    docker.enable = cfg.docker;
    libvirtd.enable = cfg.libvirtd;
    lxd.enable = cfg.lxd;
    spiceUSBRedirection.enable = cfg.spiceUSBRedirection;
    waydroid.enable = cfg.waydroid;
  };

  environment.systemPackages = with pkgs;
    mkIf (cfg.docker) [
      docker # Containers
      distrobox # Wrapper around docker to create and start linux containers
    ];

  programs.virt-manager.enable = cfg.libvirtd;
}
