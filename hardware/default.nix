{ lib, config, ... }:

let
  inherit (lib)
    attrNames
    concatMapStrings
    filter
    mkIf
    ;

  cfg = config.icedos;
in
{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    xpadneo.enable = true; # Enable XBOX Gamepad bluetooth driver
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

    extraHosts = mkIf (cfg.hardware.networking.hosts.enable) "192.168.2.99 git.dtek.gr";
  };

  boot = {
    # Virtual camera
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    kernelParams = [
      "transparent_hugepage=always"
      # Disables UMIP which fixes certain games from crashing on launch
      "clearcpuid=514"

      (
        let
          monitors = cfg.hardware.monitors;
          enabledMonitors = filter (monitor: monitors.${monitor}.enable == true) (attrNames monitors);
        in
        concatMapStrings (
          m:
          let
            name = monitors.${m}.name;
            resolution = monitors.${m}.resolution;
            refreshRate = monitors.${m}.refreshRate;
            rotation = monitors.${m}.rotation;
          in
          "video=${name}:${resolution}@${refreshRate},rotate=${rotation}"
        ) enabledMonitors
      )
    ];

    kernel.sysctl = {
      # Fixes crashes or start-up issues for games
      "vm.max_map_count" = 1048576;
      # Disable ipv6 for all interfaces
      "net.ipv6.conf.all.disable_ipv6" = !cfg.hardware.networking.ipv6;
      # Set agressiveness of swap usage
      "vm.swappiness" = cfg.system.swappiness;
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;
    };
  };

  fileSystems = mkIf (cfg.hardware.btrfsCompression.enable && cfg.hardware.btrfsCompression.root) {
    "/".options = [ "compress=zstd" ];
  };

  services = {
    fstrim.enable = true; # Enable SSD TRIM
    upower.enable = true; # Enable power management
  };

  # More sysctl params to set
  system.activationScripts.sysfs.text = ''
    echo advise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
    echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
  '';
}
