{ lib, config, ... }:

{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit =
        true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    xpadneo.enable =
      !config.xpadneo-unstable.enable; # Enable XBOX Gamepad bluetooth driver
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
    ] ++ (if (config.xpadneo-unstable.enable) then [ "hid_xpadneo" ] else [ ]);

    kernelParams =
      [ "clearcpuid=514" ]; # Fixes certain wine games crash on launch

    extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ] ++ (if (config.xpadneo-unstable.enable) then
        [ (callPackage ../system/applications/self-built/xpadneo.nix { }) ]
      else
        [ ]);

    kernel.sysctl = {
      "vm.max_map_count" = 262144;
    }; # Fixes crash when loading maps in CS2
  };

  fileSystems = lib.mkIf (config.boot.btrfs-compression.enable
    && config.boot.btrfs-compression.root.enable) {
      "/".options = [ "compress=zstd" ];
    };

  services.fstrim.enable = true; # Enable SSD TRIM
}
