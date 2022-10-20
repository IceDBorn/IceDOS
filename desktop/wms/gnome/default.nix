### DESKTOP POWERED BY GNOME ###
{ config, pkgs, ... }:

{
    imports = [
        # Setup home manager for gnome
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
            desktopManager.gnome.enable = true;
            # Configure keymap in X11
            layout = "us,gr";
            xkbVariant = "";
        };

        gnome = {
            chrome-gnome-shell.enable = true; # Allows to install GNOME Shell extensions from a web browser
            sushi.enable = true; # Quick previewer for nautilus
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
        #gnome-extension-manager # Gnome extensions manager and downloader
        gnome.dconf-editor # Edit gnome's dconf
        gnome.gnome-boxes # VM manager
        gnome.gnome-tweaks # Tweaks missing from pure Gnome
        gnomeExtensions.application-volume-mixer # Application volume mixer on the gnome control center
        gnomeExtensions.bluetooth-quick-connect # Show bluetooth devices on the gnome control center
        gnomeExtensions.caffeine # Disable auto suspend and screen blank
        gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
        gnomeExtensions.color-picker # Color picker for gnome
        gnomeExtensions.emoji-selector # Emoji selector
        gnomeExtensions.gamemode # Status indicator for gamemode on gnome
        gnomeExtensions.gsconnect # KDE Connect implementation for gnome
        gnomeExtensions.pop-shell # Tiling WM extension
        gnomeExtensions.smart-auto-move # Remember window state througout reboots and restore it
        gnomeExtensions.sound-output-device-chooser # Sound devices choose on the gnome control center
        gnomeExtensions.tray-icons-reloaded # Tray icons for gnome
        gthumb # Image viewer
        pitivi # Video editor
        tela-icon-theme # Icon theme
    ];

    # Gnome packages to exclude
    environment.gnome.excludePackages = with pkgs; [
        epiphany # Web browser
        evince # Document viewer
        gnome-console # Terminal
        gnome-text-editor # Text editor
        gnome-tour # Greeter
        gnome.cheese # Camera
        gnome.eog # Image viewer
        gnome.geary # Email
        gnome.gnome-characters # Emojis
        gnome.gnome-font-viewer # Font viewer
        gnome.gnome-maps # Maps
        gnome.gnome-software # Software center
        gnome.gnome-system-monitor # System monitoring tool
        gnome.simple-scan # Scanner
        gnome.yelp # Help
    ];

    # Font required by powerlevel10k
    fonts.fonts = with pkgs; [ meslo-lgs-nf ];
}
