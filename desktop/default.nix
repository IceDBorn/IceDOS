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
            displayManager.gdm.enable = true;
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

    # Gnome packages to install
    environment.systemPackages = with pkgs; [
        bibata-cursors # Material cursors
        fragments # Bittorrent client following Gnome UI standards
        gnome.adwaita-icon-theme # GTK theme
        gthumb # Image viewer
        pitivi # Video editor
        tela-icon-theme # Icon theme
    ];

    # Font required by powerlevel10k
    fonts.fonts = with pkgs; [ meslo-lgs-nf ];
}
