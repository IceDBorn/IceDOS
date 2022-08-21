### PACKAGES INSTALLED ON ALL USERS ###
{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        alacritty # Terminal
        android-tools # Tools for debugging android devices
        aria # Terminal downloader with multiple connections support
        bibata-cursors # Material cursors
        firefox # Browser
        flatpak # Source for more applications
        fragments # Bittorrent client following Gnome UI standards
        gimp # Image editor
        git # Distributed version control system
        gnome.gnome-tweaks # Tweaks missing from pure Gnome
        gnomeExtensions.application-volume-mixer # Application volume mixer on the gnome control center
        gnomeExtensions.bluetooth-quick-connect # Show bluetooth devices on the gnome control center
        gnomeExtensions.clipboard-indicator # Clipboard indicator for gnome
        gnomeExtensions.color-picker # Color picker for gnome
        gnomeExtensions.coverflow-alt-tab # Makes alt tab on gnome cooler
        gnomeExtensions.gamemode # Status indicator for gamemode on gnome
        gnomeExtensions.gsconnect # KDE Connect implementation for gnome
        #gnomeExtensions.material-shell # Tiling WM for gnome
        gnomeExtensions.sound-output-device-chooser # Sound devices choose on the gnome control center
        gnomeExtensions.tray-icons-reloaded # Tray icons for gnome
        helvum # Pipewire patchbay
        jetbrains.webstorm # All purpose IDE
        mullvad-vpn # VPN Client
        nautilus-open-any-terminal # Open any terminal from nautilus context menu
        ntfs3g # Support NTFS drives
        obs-studio # Recording/Livestream
        onlyoffice-bin # Microsoft Office alternative for Linux
        pitivi # Video editor
        plata-theme # Gnome theme
        ranger # Terminal file manager
        rnnoise-plugin # A real-time noise suppression plugin
        signal-desktop # Encrypted messaging platform
        sublime4 # Text editor
        syncthing # Local file sync
        tela-icon-theme # Icon theme
        tree # Display folder content at a tree format
        unrar # Support opening rar files
        usbimager # ISO Burner
        wget # Terminal downloader
        wine # Compatibility layer capable of running Windows applications
        winetricks # Wine prefix settings manager
        woeusb # Windows ISO Burner
        zenstates # Ryzen CPU controller
    ];
}