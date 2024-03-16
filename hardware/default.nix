{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf optional;

  cfg = config.icedos;
  monitors = cfg.hardware.monitors;
in {
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit =
        true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    xpadneo.enable =
      !cfg.hardware.xpadneoUnstable; # Enable XBOX Gamepad bluetooth driver
    bluetooth.enable = true;
    uinput.enable = true; # Enable uinput support
  };

  # Set memory limits
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "2147483648";
    }

    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "2147483648";
    }
  ];

  networking = {
    hostName = "${cfg.hardware.networking.hostname}";

    extraHosts =
      mkIf (cfg.hardware.networking.hosts.enable) "192.168.2.99 git.dtek.gr";
  };

  boot = {
    kernelModules = [
      "v4l2loopback" # Virtual camera
      "uinput"
    ] ++ optional (cfg.hardware.xpadneoUnstable) "hid_xpadneo";

    kernelParams = [
      "transparent_hugepage=always"
      # Fixes certain wine games crash on launch
      "clearcpuid=514"
    ] ++ optional (monitors.main.enable)
      "video=${monitors.main.name}:${monitors.main.resolution}@${monitors.main.refreshRate},rotate=${monitors.main.rotation}"
      ++ optional (monitors.secondary.enable)
      "video=${monitors.secondary.name}:${monitors.secondary.resolution}@${monitors.secondary.refreshRate},rotate=${monitors.secondary.rotation}";

    extraModulePackages = with config.boot.kernelPackages;
      [ pkgs.v4l2loopback-git ]
      ++ optional (cfg.hardware.xpadneoUnstable) pkgs.xpadneo-git;

    kernel.sysctl = {
      # Fixes crash when loading maps in CS2
      "vm.max_map_count" = 262144;
      # Disable ipv6 for all interfaces
      "net.ipv6.conf.all.disable_ipv6" = !cfg.hardware.networking.ipv6;
      # Set agressiveness of swap usage
      "vm.swappiness" = cfg.system.swappiness;
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;
    };
  };

  fileSystems = mkIf (cfg.hardware.btrfsCompression.enable
    && cfg.hardware.btrfsCompression.root) {
      "/".options = [ "compress=zstd" ];
    };

  services.fstrim.enable = true; # Enable SSD TRIM

  # More sysctl params to set
  system.activationScripts.sysfs.text = ''
    echo advise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
    echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
  '';
}
