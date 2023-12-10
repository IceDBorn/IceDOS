{ lib, config, ... }:

{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit =
        true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    xpadneo.enable =
      !config.hardware.xpadneoUnstable; # Enable XBOX Gamepad bluetooth driver
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

  networking.extraHosts =
    lib.mkIf config.hardware.networking.hosts.enable "192.168.2.99 git.dtek.gr";

  boot = {
    kernelModules = [
      "v4l2loopback" # Virtual camera
      "uinput"
    ] ++ lib.optional config.hardware.xpadneoUnstable "hid_xpadneo";

    kernelParams = [
      # Fixes certain wine games crash on launch
      "clearcpuid=514"
    ] ++ lib.optional config.hardware.monitors.main.enable
      "video=${config.hardware.monitors.main.name}:${config.hardware.monitors.main.resolution}@${config.hardware.monitors.main.refreshRate}"
      ++ lib.optional config.hardware.monitors.secondary.enable
      "video=${config.hardware.monitors.secondary.name}:${config.hardware.monitors.secondary.resolution}@${config.hardware.monitors.secondary.refreshRate}";

    extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ] ++ lib.optional config.hardware.xpadneoUnstable
      (callPackage ../system/applications/self-built/xpadneo.nix { });

    kernel.sysctl = {
      # Fixes crash when loading maps in CS2
      "vm.max_map_count" = 262144;
      # Disable ipv6 for all interfaces
      "net.ipv6.conf.all.disable_ipv6" = !config.hardware.networking.ipv6;
      # Set agressiveness of swap usage
      "vm.swappiness" = config.system.swappiness;
    };
  };

  fileSystems = lib.mkIf (config.hardware.btrfsCompression.enable
    && config.hardware.btrfsCompression.root) {
      "/".options = [ "compress=zstd" ];
    };

  services.fstrim.enable = true; # Enable SSD TRIM
}
