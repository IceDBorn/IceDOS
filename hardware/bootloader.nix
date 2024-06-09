{ config, lib, ... }:

let
  inherit (lib) mkIf;

  cfg = config.icedos;
in
{
  boot = {
    loader = {
      efi = mkIf (cfg.bootloader.systemd-boot.enable) {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.bootloader.systemd-boot.mountPoint;
      };

      grub = mkIf (cfg.bootloader.grub.enable) {
        enable = true;
        device = cfg.bootloader.grub.device;
        useOSProber = true;
        enableCryptodisk = true;
        configurationLimit = 10;
      };

      systemd-boot = mkIf (cfg.bootloader.systemd-boot.enable) {
        enable = true;
        configurationLimit = cfg.system.generations.bootEntries;
        # Select the highest resolution for the bootloader
        consoleMode = "max";
      };

      # Boot default entry after 1 second
      timeout = 1;
    };

    initrd.secrets = mkIf (cfg.bootloader.grub.enable) { "/crypto_keyfile.bin" = null; };

    plymouth.enable = cfg.bootloader.animation;
  };
}
