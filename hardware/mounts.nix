{ lib, config, ... }:

lib.mkIf config.mounts.enable {
  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/89afb683-90b4-4291-82af-5d3238c8bd3d";
    fsType = "btrfs";
    options = lib.mkIf (config.boot.btrfs-compression.enable
      && config.boot.btrfs-compression.mounts.enable) [ "compress=zstd" ];
  };

  fileSystems."/mnt/Storage" = {
    device = "/dev/disk/by-uuid/4b2d6cf0-f73a-4b4a-820a-db5b5aa17efa";
    fsType = "btrfs";
    options = lib.mkIf (config.boot.btrfs-compression.enable
      && config.boot.btrfs-compression.mounts.enable) [ "compress=zstd" ];
  };
}
