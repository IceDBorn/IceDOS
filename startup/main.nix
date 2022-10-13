{ config, pkgs, home-manager, ... }:

{
    home-manager.users.${config.main.user.username}.home.file = {
        # Add discord-screenaudio to startup
        ".config/autostart/de.shorsh.discord-screenaudio.desktop" = {
            text = ''
                [Desktop Entry]
                Type=Application
                Name=discord-screenaudio
                Exec=flatpak run --branch=stable --arch=x86_64 --command=discord-screenaudio de.shorsh.discord-screenaudio
                Icon=de.shorsh.discord-screenaudio
                Terminal=false
                X-Flatpak=de.shorsh.discord-screenaudio
            '';
            recursive = true;
        };

        # Add mullvad vpn to startup
        ".config/autostart/mullvad-vpn.desktop" = {
            text = ''
                [Desktop Entry]
                Name=Mullvad VPN
                Exec=${pkgs.mullvad-vpn}/bin/mullvad-vpn --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland
                Terminal=false
                Type=Application
                Icon=mullvad-vpn
                StartupWMClass=Mullvad VPN
                Comment=Mullvad VPN client
                Categories=Network;
            '';
            recursive = true;
        };

        # Add signal to startup
        ".config/autostart/signal-desktop.desktop" = {
            text = ''
                [Desktop Entry]
                Actions=new-empty-window
                Categories=Network;InstantMessaging;Chat
                Comment=Private messaging from your desktop
                Exec=signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U
                GenericName=Text Editor
                Icon=signal-desktop
                Name=Signal
                Terminal=false
                Type=Application
                Version=1.4

                [Desktop Action new-empty-window]
                Exec=codium --new-window %F
                Icon=code
                Name=New Empty Window
            '';
            recursive = true;
        };

        # Add steam to startup
        ".config/autostart/steam.desktop" = {
            source = ./steam.desktop;
            recursive = true;
        };
    };
}