{ config, pkgs, ... }:

{
    imports =
    [
        # Include the results of the hardware scan, generate yours with "nixos-generate-config"
        ./hardware-configuration.nix
    ];

    # Grub configuration
    boot = {
        loader = {
            systemd-boot.enable = true;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
        };
        # Use Zen kernel
        kernelPackages = pkgs.linuxPackages_zen;
        # Virtual camera for OBS
        kernelModules = [ "v4l2loopback" ];
    };

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
        alacritty # Terminal
        android-tools # Tools for debugging android devices
        aria # Terminal downloader with multiple connections support
        firefox-bin # Browser
        fragments # Bittorrent client following Gnome UI standards
        gimp # Image editor
        git # Distributed version control system
        gnome.gnome-tweaks # Tweaks missing from pure Gnome
        helvum # Pipewire patchbay
        ntfs3g # Support NTFS drives
        obs-studio # Recording/Livestream
        os-prober # Detect all operating systems
        pitivi # Video editor
        ranger # Terminal file manager
        signal-desktop # Encrypted messaging platform
        steam # Gaming store
        syncthing # Local file sync
        tree # Display folder content at a tree format
        unrar # Support opening rar files
        wget # Terminal downloader
        wine # Compatibility layer capable of running Windows applications
        winetricks # Wine prefix settings manager
    ];

    # Do not change without checking the docs
    system.stateVersion = "22.05";
}