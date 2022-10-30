### DESKTOP POWERED BY GNOME ###
{ config, pkgs, ... }:

{
    imports = [
        # Install desktop environments and window managers
        ./wms
        # Setup home manager for desktop
        ./home.nix
    ];

    # Set your time zone
    time.timeZone = "Europe/Bucharest";

    # Set your locale settings
    i18n = {
        defaultLocale = "en_US.utf8";
        extraLocaleSettings.LC_MEASUREMENT = "es_ES.utf8";
    };

    services = {
        xserver = {
            # Enable the X11 windowing system
            enable = true;
            # Enable the GNOME Desktop Environment
            displayManager.gdm = {
                enable = true;
                autoSuspend = false;
            };
            # Configure keymap in X11
            layout = "us,gr";
            xkbVariant = "";
        };

        # Enable sound with pipewire
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    # Enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand, required by pipewire
    security.rtkit.enable = true;
    programs.dconf.enable = true;

    networking = {
        # Define your hostname
        hostName = "nixos";
        # Enable networking
        networkmanager.enable = true;
        # Disable firewall
        firewall.enable = false;
    };

    # Show asterisks when typing sudo password
    security.sudo.extraConfig = "Defaults pwfeedback";

    environment = {
        sessionVariables = {
            # Use gtk theme for qt apps
            QT_QPA_PLATFORMTHEME= "gnome";
        };

        # Packages to install for all wms
        systemPackages = with pkgs; [
            bibata-cursors # Material cursors
            fragments # Bittorrent client following Gnome UI standards
            gnome.adwaita-icon-theme # GTK theme
            gnome.gnome-boxes # VM manager
            gthumb # Image viewer
            pitivi # Video editor
            qgnomeplatform # Use GTK theme for QT apps
            tela-icon-theme # Icon theme
        ];
    };

    # Fonts to install
    fonts.fonts = with pkgs; [ meslo-lgs-nf cantarell-fonts jetbrains-mono font-awesome ];
}
