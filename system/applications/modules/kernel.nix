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
  monitors = cfg.hardware.monitors;
  noMonitors = length (monitors) == 0;
in
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ]; # Virtual camera

    kernelPackages =
      with pkgs;
      if (!builtins.pathExists /etc/icedos-version) then
        linuxPackages_stable
      else
        {
          cachyos =
            if (cfg.hardware.devices.server.enable) then
              linuxPackages_cachyos-server
            else
              linuxPackages_cachyos;

          jovian = linuxPackages_jovian;
          latest = linuxPackages_latest;
          stable = linuxPackages_stable;
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

  chaotic.scx = {
    enable = false;
    # enable = (config.boot.kernelPackages.kernel.passthru.config.CONFIG_SCHED_CLASS_EXT or null) == "y";
    package = pkgs.scx.rustland;
    scheduler = "scx_rustland";
  };

  # More sysctl params to set
  system.activationScripts.sysfs.text = ''
    echo advise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
    echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
  '';
}
