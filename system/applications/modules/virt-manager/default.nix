{
  config,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
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
}
