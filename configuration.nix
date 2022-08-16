{ config, pkgs, ... }:

{
    imports =
    [
        # Include the results of the hardware scan
        ./hardware-configuration.nix
    ];

    # Grub configuration
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    networking = {
        # Define your hostname
        hostname = "icedborn";
        # Enable networking
        networkmanager.enable = true;
        # Disable firewall
        firewall.enable = false;
    };

    # Set your time zone.
    time.timeZone = "Europe/Bucharest";

    i18n = {
        defaultLocale = "en_US.utf8";
        extraLocaleSettings = {
            LC_MEASUREMENT = "es_ES.utf8";
        };
    };

    services = {
        xserver = {
            # Enable the X11 windowing system
            enable = true;
            # Enable the GNOME Desktop Environment
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
            # Configure keymap in X11
            layout = "us";
            xkbVariant = "";
        };

        # Enable CUPS to print documents
        printing.enable = true;

        # Enable sound with pipewire
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        # Enable SSH
        openssh.enable = true;
    };

    sound.enable = true;
    # Disable pulseaudio
    hardware.pulseaudio.enable = false;
    # Enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand
    security.rtkit.enable = true;

    users = {
        # Set default shell to zsh
        defaultShell = pkgs.zsh;

        # Define users below
        users = {
            icedborn = {
                createHome = true;
                home = "/home/icedborn";
                useDefaultShell = true;
                # Default password used for first login, change later with passwd
                password = "1";
                isNormalUser = true;
                description = "IceDBorn";
                extraGroups = [ "networkmanager" "wheel" ];
                # Packages installed for this specific user only
                packages = with pkgs; [
                    firefox
                ];
            };

            work = {
                createHome = true;
                home = "/home/work";
                useDefaultShell = true;
                # Default password used for first login, change later with passwd
                password = "1";
                isNormalUser = true;
                description = "Work";
                extraGroups = [ "networkmanager" "wheel" ];
                # Packages installed for this specific user only
                packages = with pkgs; [
                    firefox
                ];
            };
        };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Packages installed system-wide
    environment.systemPackages = with pkgs; [
        vim
    ];

    # Do not change without checking the docs
    system.stateVersion = "22.05";
}