{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware.virtualisation;
in
mkIf (cfg.libvirtd) {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
