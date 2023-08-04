{ lib, config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

    nvidia = lib.mkIf (config.nvidia.enable && config.nvidia.patch.enable) {
      package = config.nur.repos.arc.packages.nvidia-patch.override {
        nvidia_x11 = config.boot.kernelPackages.nvidiaPackages.stable;
      }; # Patch the driver for nvfbc
    };

    xpadneo.enable = true; # Enable XBOX Gamepad bluetooth driver
    bluetooth.enable = true;
    uinput.enable = true; # Enable uinput support
  };

  environment.systemPackages = lib.mkIf (config.laptop.enable && config.nvidia.enable) [ nvidia-offload ]; # Use nvidia-offload to launch programs using the nvidia GPU

  # Set memory limits
  security.pam.loginLimits =
    [
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
      "xpadneo"
      "uinput"
    ];

    kernelParams = [ "clearcpuid=514" ]; # Fixes certain wine games crash on launch

    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    kernel.sysctl = { "vm.max_map_count" = 262144; }; # Fixes crash when loading maps in CS2
  };

  fileSystems = lib.mkIf (config.boot.btrfs-compression.enable && config.boot.btrfs-compression.root.enable) {
    "/".options = [ "compress=zstd" ];
  };

  services.fstrim.enable = true; # Enable SSD TRIM
}
