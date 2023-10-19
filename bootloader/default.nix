{ config, lib, ... }:

{
  boot = {
    loader = {
      efi = lib.mkIf config.boot.systemd-boot.enable {
        canTouchEfiVariables = true;
        efiSysMountPoint = config.boot.systemd-boot.efi-mount-path;
      };

      grub = lib.mkIf config.boot.grub.enable {
        enable = true;
        device = config.boot.grub.device;
        useOSProber = true;
        enableCryptodisk = true;
        configurationLimit = 10;
      };

      systemd-boot = lib.mkIf config.boot.systemd-boot.enable {
        enable = true;
        configurationLimit = 10;
        # Select the highest resolution for the bootloader
        consoleMode = "max";
      };

      # Boot default entry after 1 second
      timeout = 1;
    };

    initrd.secrets =
      lib.mkIf config.boot.grub.enable { "/crypto_keyfile.bin" = null; };

    plymouth.enable = config.boot.animation.enable;
  };
}
