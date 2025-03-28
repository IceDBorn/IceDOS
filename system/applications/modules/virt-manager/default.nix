{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
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

  boot.kernelParams = [
    # Allows passthrough of independent devices, that are members of larger IOMMU groups
    # It only affects kernels with ACS Override support. Ex: CachyOS, Liquorix, Zen
    "pcie_acs_override=downstream,multifunction"
  ] ++ (
      # Enable PCIe passthrough
      if (cpus.amd.enable)
      then [ "amd_iommu=on" ]
      else if (cpus.intel)
      then [ "intel_iommu=on" ]
      else []
  );
}
