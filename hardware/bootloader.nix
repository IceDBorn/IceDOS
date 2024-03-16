{ config, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos.boot;
in {
  boot = {
    loader = {
      efi = mkIf (cfg.systemd-boot.enable) {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.systemd-boot.mountPoint;
      };

      grub = mkIf (cfg.grub.enable) {
        enable = true;
        device = cfg.grub.device;
        useOSProber = true;
        enableCryptodisk = true;
        configurationLimit = 10;
      };

      systemd-boot = mkIf (cfg.systemd-boot.enable) {
        enable = true;
        configurationLimit = 10;
        # Select the highest resolution for the bootloader
        consoleMode = "max";
      };

      # Boot default entry after 1 second
      timeout = 1;
    };

    initrd.secrets = mkIf (cfg.grub.enable) { "/crypto_keyfile.bin" = null; };

    plymouth.enable = cfg.animation;
  };
}
