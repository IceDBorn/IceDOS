{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
in
{
  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true; # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
    };

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
    extraHosts = mkIf (cfg.hardware.networking.hosts) "192.168.2.99 git.dtek.gr";
    hostName = "${cfg.hardware.networking.hostname}";
  };

  services = {
    fstrim.enable = true; # Enable SSD TRIM
    upower.enable = true; # Enable power management
  };

  zramSwap = {
    enable = true;
    memoryPercent = 10;
  };
}
