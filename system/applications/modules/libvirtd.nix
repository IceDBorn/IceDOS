{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.virtualisation;
in
mkIf (cfg.libvirtd) {
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
