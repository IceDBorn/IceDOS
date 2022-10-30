{ config, pkgs, home-manager, ... }:

{
    home-manager.users.${config.main.user.username}.home.file = {
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
