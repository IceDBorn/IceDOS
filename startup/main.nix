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

        # Add 2 terminals to startup
#        ".config/autostart/startup-terminals.desktop" = {
#            text = ''
#                [Desktop Entry]
#                Categories=System;TerminalEmulator
#                Comment=A fast, cross-platform, OpenGL terminal emulator
#                Exec=bash -c 'kitty & kitty'
#                GenericName=Terminal
#                Icon=Kitty
#                Name=Startup Terminals
#                Terminal=false
#                Type=Application
#                Version=1.4
#            '';
#            recursive = true;
#        };

        # Add steam to startup
        ".config/autostart/steam.desktop" = {
            source = ./steam.desktop;
            recursive = true;
        };

        # Add system monitoring center to startup
#        ".config/autostart/com.github.hakand34.system-monitoring-center.desktop" = {
#            source = ./system-monitoring-center.desktop;
#            recursive = true;
#        };
    };
}
