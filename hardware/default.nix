{
  config,
  ...
}:

let
  cfg = config.icedos;
in
{
  boot.kernelModules = [ "ntsync" ];

  hardware = {
    enableAllFirmware = true;
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
    extraHosts = cfg.hardware.networking.hosts;
    hostName = "${cfg.hardware.networking.hostname}";
  };

  services = {
    fstrim.enable = true; # Enable SSD TRIM
    upower.enable = true; # Enable power management
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  zramSwap = {
    enable = true;
    memoryPercent = 10;
  };
}
