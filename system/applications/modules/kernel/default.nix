{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapStrings
    length
    optionals
    ;

  cfg = config.icedos;

  kernel =
    cfg.system.kernel == "cachyos"
    || cfg.system.kernel == "cachyos-server"
    || cfg.system.kernel == "valve";

  monitors = cfg.hardware.monitors;
  noMonitors = length (monitors) == 0;
in
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ]; # Virtual camera

    kernelPackages =
      with pkgs;
      if (cfg.internals.isFirstBuild && kernel) then
        linuxPackages
      else
        {
          cachyos = linuxPackages_cachyos;
          cachyos-server = linuxPackages_cachyos-server;
          latest = linuxPackages_latest;
          lts = linuxPackages;
          valve = linuxPackages_jovian;
          zen = linuxPackages_zen;
        }
        .${cfg.system.kernel};

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
            name = m.name;
            resolution = m.resolution;
            refreshRate = builtins.toString (m.refreshRate);
            rotation = builtins.toString (m.rotation);
          in
          "video=${name}:${resolution}@${refreshRate},rotate=${rotation}"
        ) monitors)
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
