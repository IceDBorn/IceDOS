{ config, pkgs, ... }:

{
    boot = {
        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };

            systemd-boot = {
                enable = true;
                # Keep the last 10 nixOS configurations
                configurationLimit = 10;
            };
        };
        # Use Zen kernel
        kernelPackages = pkgs.linuxPackages_zen;
    };
}
