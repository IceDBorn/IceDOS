{ lib, config, ...}:

lib.mkIf config.mounts.enable {
	fileSystems."/mnt/Games" = {
		device = "/dev/disk/by-uuid/4a8bd4b6-e5c9-4e98-a7ca-31c907967461";
		fsType = "btrfs";
		options = lib.mkIf config.boot.btrfs-compression.enable [ "compress=zstd" ];
	};

	fileSystems."/mnt/Storage" = {
		device = "/dev/disk/by-uuid/4b2d6cf0-f73a-4b4a-820a-db5b5aa17efa";
		fsType = "btrfs";
		options = lib.mkIf config.boot.btrfs-compression.enable [ "compress=zstd" ];
	};
}
