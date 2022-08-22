### DESKTOP POWERED BY GNOME ###
{ config, pkgs, ... }:

{
    imports = [ ./home.nix ]; # Home manager specific stuff

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

    environment.systemPackages = with pkgs; [
        bibata-cursors # Material cursors
        fragments # Bittorrent client following Gnome UI standards
        gnome.gnome-tweaks # Tweaks missing from pure Gnome
        gnomeExtensions.application-volume-mixer # Application volume mixer on the gnome control center
        gnomeExtensions.bluetooth-quick-connect # Show bluetooth devices on the gnome control center
        gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
        gnomeExtensions.color-picker # Color picker for gnome
        gnomeExtensions.coverflow-alt-tab # Makes alt tab on gnome cooler
        gnomeExtensions.gamemode # Status indicator for gamemode on gnome
        gnomeExtensions.gsconnect # KDE Connect implementation for gnome
        # Material shell is broken at the moment
        #gnomeExtensions.material-shell # Tiling WM for gnome
        gnomeExtensions.sound-output-device-chooser # Sound devices choose on the gnome control center
        gnomeExtensions.tray-icons-reloaded # Tray icons for gnome
        nautilus-open-any-terminal # Open any terminal from nautilus context menu
        pitivi # Video editor
        plata-theme # Gnome theme
        tela-icon-theme # Icon theme
    ];
}