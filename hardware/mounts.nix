{ lib, config, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos.hardware;
  btrfsCompression = cfg.btrfsCompression;
in mkIf (cfg.mounts) {
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/89afb683-90b4-4291-82af-5d3238c8bd3d";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts)
      [ "compress=zstd" ];
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/4b2d6cf0-f73a-4b4a-820a-db5b5aa17efa";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts)
      [ "compress=zstd" ];
  };

  fileSystems."/mnt/ssdgames" = {
    device = "/dev/disk/by-uuid/040329ae-685d-4ba6-8bdd-e0a9785f9672";
    fsType = "btrfs";
    options = mkIf (btrfsCompression.enable && btrfsCompression.mounts)
      [ "compress=zstd" ];
  };
}
