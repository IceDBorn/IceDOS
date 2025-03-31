{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf optional;
  inherit (config.icedos.hardware) cpus;
  cfg = config.icedos.system;
in
mkIf (cfg.virtualisation.virtManager) {
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  users.users = mapAttrs (user: _: {
    extraGroups = [ "libvirtd" ];
  }) cfg.users;

  boot.kernelParams =
    [
      # Allows passthrough of independent devices, that are members of larger IOMMU groups
      # It only affects kernels with ACS Override support. Ex: CachyOS, Liquorix, Zen
      "pcie_acs_override=downstream,multifunction"
    ]
    ++ optional cpus.amd.enable "amd_iommu=on"
    ++ optional cpus.intel "intel_iommu=on";
}
