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

    extraHosts = mkIf (cfg.hardware.networking.hosts) "192.168.2.99 git.dtek.gr";
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
            refreshRate = builtins.toString (monitors.${m}.refreshRate);
            rotation = builtins.toString (monitors.${m}.rotation);
          in
          "video=${name}:${resolution}@${refreshRate},rotate=${rotation}"
        ) enabledMonitors
      )
    ];

    kernel.sysctl = {
      "net.ipv6.conf.all.disable_ipv6" = !cfg.hardware.networking.ipv6; # Disable ipv6 for all interfaces
      "page-cluster" = 1;
      "vm.compaction_proactiveness" = 0;
      "vm.max_map_count" = 1048576; # Fixes crashes or start-up issues for games
      "vm.page_lock_unfairness" = 1;
      "vm.swappiness" = builtins.toString (cfg.system.swappiness); # Set agressiveness of swap usage
    };
  };

  fileSystems = mkIf (cfg.hardware.btrfs.compression.enable && cfg.hardware.btrfs.compression.root) {
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

  zramSwap = {
    enable = true;
    memoryPercent = 10;
  };
}
