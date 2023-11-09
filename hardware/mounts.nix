{ lib, config, ... }:

lib.mkIf config.hardware.mounts {
  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/89afb683-90b4-4291-82af-5d3238c8bd3d";
    fsType = "btrfs";
    options = lib.mkIf (config.hardware.btrfsCompression.enable
      && config.hardware.btrfsCompression.mounts) [ "compress=zstd" ];
  };

  fileSystems."/mnt/Storage" = {
    device = "/dev/disk/by-uuid/4b2d6cf0-f73a-4b4a-820a-db5b5aa17efa";
    fsType = "btrfs";
    options = lib.mkIf (config.hardware.btrfsCompression.enable
      && config.hardware.btrfsCompression.mounts) [ "compress=zstd" ];
  };

  fileSystems."/mnt/Windows" = {
    device = "/dev/disk/by-uuid/8AAE4B96AE4B79A9";
    fsType = "ntfs";
  };
}
