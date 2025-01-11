{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.hardware;
  btrfsCompression = cfg.btrfs.compression;
in
mkIf (cfg.mounts) {
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/040329ae-685d-4ba6-8bdd-e0a9785f9672";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts) [ "compress=zstd" ];
  };

  fileSystems."/mnt/games2" = {
    device = "/dev/disk/by-uuid/60876d91-f863-45db-88c5-4c707879588f";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts) [ "compress=zstd" ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/89730200-942d-4a5c-893f-0196c87435d2";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts) [ "compress=zstd" ];
  };
}
