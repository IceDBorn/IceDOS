{ lib, config, ... }:

{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit =
        true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    xpadneo.enable =
      !config.hardware.xpadneo-unstable.enable; # Enable XBOX Gamepad bluetooth driver
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

  boot = {
    kernelModules = [
      "v4l2loopback" # Virtual camera
      "uinput"
    ] ++ lib.optional config.hardware.xpadneo-unstable.enable "hid_xpadneo";

    kernelParams =
      [ "clearcpuid=514" ]; # Fixes certain wine games crash on launch

    extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ] ++ lib.optional config.hardware.xpadneo-unstable.enable
      (callPackage ../system/applications/self-built/xpadneo.nix { });

    kernel.sysctl = {
      "vm.max_map_count" = 262144;
    }; # Fixes crash when loading maps in CS2
  };

  fileSystems = lib.mkIf (config.hardware.btrfs-compression.enable
    && config.hardware.btrfs-compression.root.enable) {
      "/".options = [ "compress=zstd" ];
    };

  services.fstrim.enable = true; # Enable SSD TRIM
}
