{ lib, config, ... }:

lib.mkIf config.mounts.enable {
  fileSystems."/mnt/SSDGames" = {
    device = "/dev/disk/by-uuid/2b04380c-cefe-4915-a1f4-26bef6ebc360";
    fsType = "btrfs";
    options = lib.mkIf
      (config.boot.btrfs-compression.enable
        && config.boot.btrfs-compression.mounts.enable) [ "compress=zstd" ];
  };

  fileSystems."/mnt/HDDGames" = {
    device = "/dev/disk/by-uuid/e7e03cc8-e8fe-47e2-b48a-c6dbd1903112";
    fsType = "btrfs";
    options = lib.mkIf
      (config.boot.btrfs-compression.enable
        && config.boot.btrfs-compression.mounts.enable) [ "compress=zstd" ];
  };

  fileSystems."/mnt/Windows" = {
    device = "/dev/disk/by-uuid/3032AC4732AC13BE";
    fsType = "ntfs";
  };
}
