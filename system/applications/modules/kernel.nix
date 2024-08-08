{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    concatMapStrings
    filter
    length
    optionals
    ;

  cfg = config.icedos;
  enabledMonitors = filter (monitor: monitors.${monitor}.enable == true) (attrNames monitors);
  monitors = cfg.hardware.monitors;
  noMonitors = length (enabledMonitors) == 0;
in
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ]; # Virtual camera

    kernelPackages =
      # Use CachyOS optimized linux kernel
      if (!builtins.pathExists /etc/icedos-version) then
        pkgs.linuxPackages_zen
      else if
        (
          cfg.applications.steam.enable
          && cfg.applications.steam.session.enable
          && cfg.applications.steam.session.useValveKernel
        )
      then
        pkgs.linuxPackages_jovian
      else if (!cfg.hardware.devices.steamdeck && cfg.hardware.devices.server.enable) then
        pkgs.linuxPackages_cachyos-server
      else
        pkgs.linuxPackages_cachyos;

    kernelParams =
      [
        "transparent_hugepage=always"
        # Disables UMIP which fixes certain games from crashing on launch
        "clearcpuid=514"
      ]
      ++ optionals (!noMonitors) [
        (concatMapStrings (
          m:
          let
            name = monitors.${m}.name;
            resolution = monitors.${m}.resolution;
            refreshRate = builtins.toString (monitors.${m}.refreshRate);
            rotation = builtins.toString (monitors.${m}.rotation);
          in
          "video=${name}:${resolution}@${refreshRate},rotate=${rotation}"
        ) enabledMonitors)
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

  # More sysctl params to set
  system.activationScripts.sysfs.text = ''
    echo advise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
    echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
  '';
}
