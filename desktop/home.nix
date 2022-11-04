{ config, pkgs, home-manager, ... }:

{
    home-manager.users.${config.main.user.username} = {
        gtk = {
            # Change GTK themes
            enable = true;
            theme = {
                name = "Adwaita-dark";
            };
            cursorTheme = {
                name = "Bibata-Modern-Classic";
            };
            iconTheme = {
                name = "Tela-black-dark";
            };
        };

        dconf.settings = {
            # Nautilus path bar is always editable
            "org/gnome/nautilus/preferences" = {
                always-use-location-entry = true;
            };
        };

        # Force vscodium to use wayland
#        xdg.desktopEntries.codium = {
#            type = "Application";
#            exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
#            icon = "code";
#            terminal = false;
#            categories = [ "Utility" "TextEditor" "Development" "IDE" ];
#            name = "VSCodium";
#            genericName = "Text Editor";
#            comment = "Code Editing. Redefined.";
#            actions.new-empty-window = {
#                "exec" = "codium --new-window %F";
#                "icon" = "code";
#                "name" = "New Empty Window";
#            };
#        };

        # Force signal to use wayland
        xdg.desktopEntries.signal-desktop = {
            type = "Application";
            exec = "signal-desktop --use-tray-icon --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
            icon = "signal-desktop";
            terminal = false;
            categories = [ "Network" "InstantMessaging" "Chat" ];
            name = "Signal";
            genericName = "Text Editor";
            comment = "Private messaging from your desktop";
        };

        # Force discord to use wayland and disable gpu to allow it to work
        xdg.desktopEntries.discord = {
            type = "Application";
            exec = "discord --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "discord";
            name = "Discord";
        };

        # Force webcord to use wayland
        xdg.desktopEntries.webcord = {
            type = "Application";
            exec = "io.github.spacingbat3.webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "webcord";
            name = "Webcord";
        };

        home.file = {
            # Add zsh theme to zsh directory
            ".config/zsh/zsh-theme.zsh" = {
                source = ../configs/zsh-theme.zsh;
                recursive = true;
            };

            # Add protondown script to zsh directory
            ".config/zsh/protondown.sh" = {
                source = ../scripts/protondown.sh;
                recursive = true;
            };

            # Add firefox privacy profile overrides
#            ".mozilla/firefox/privacy/user-overrides.js" = {
#                source = ../configs/firefox-user-overrides.js;
#                recursive = true;
#            };

            # Set firefox to privacy profile
#            ".mozilla/firefox/profiles.ini" = {
#                source = ../configs/firefox-profiles.ini;
#                recursive = true;
#            };

            # Add noise suppression microphone
            ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                source = ../configs/pipewire.conf;
                recursive = true;
            };

            # Add btop config
            ".config/btop/btop.conf" = {
                source = ../configs/btop.conf;
                recursive = true;
            };
        };
    };

    home-manager.users.${config.work.user.username} = {
        gtk = {
            # Change GTK themes
            enable = true;
            theme = {
                name = "Adwaita-dark";
            };
            cursorTheme = {
                name = "Bibata-Modern-Classic";
            };
            iconTheme = {
                name = "Tela-black-dark";
            };
        };

        dconf.settings = {
            # Nautilus path bar is always editable
            "org/gnome/nautilus/preferences" = {
                always-use-location-entry = true;
            };
        };

        # Force vscodium to use wayland
#        xdg.desktopEntries.codium = {
#            type = "Application";
#            exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
#            icon = "code";
#            terminal = false;
#            categories = [ "Utility" "TextEditor" "Development" "IDE" ];
#            name = "VSCodium";
#            genericName = "Text Editor";
#            comment = "Code Editing. Redefined.";
#            actions.new-empty-window = {
#                "exec" = "codium --new-window %F";
#                "icon" = "code";
#                "name" = "New Empty Window";
#            };
#        };

        # Force signal to use wayland
#        xdg.desktopEntries.signal-desktop = {
#            type = "Application";
#            exec = "signal-desktop --use-tray-icon --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
#            icon = "signal-desktop";
#            terminal = false;
#            categories = [ "Network" "InstantMessaging" "Chat" ];
#            name = "Signal";
#            genericName = "Text Editor";
#            comment = "Private messaging from your desktop";
#        };

        # Force discord to use wayland and disable gpu to allow it to work
        xdg.desktopEntries.discord = {
            type = "Application";
            exec = "discord --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "discord";
            name = "Discord";
        };

        # Force webcord to use wayland
        xdg.desktopEntries.webcord = {
            type = "Application";
            exec = "io.github.spacingbat3.webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
            icon = "webcord";
            name = "WebcordWayland";
        };

        # Force discord to use wayland and disable gpu to allow it to work
        xdg.desktopEntries.slack = {
            type = "Application";
            exec = "slack --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
            icon = "slack";
            name = "Slack";
        };

        home.file = {
            # Add zsh theme to zsh directory
            ".config/zsh/zsh-theme.zsh" = {
                source = ../configs/zsh-theme.zsh;
                recursive = true;
            };

            # Add protondown script to zsh directory
            ".config/zsh/protondown.sh" = {
                source = ../scripts/protondown.sh;
                recursive = true;
            };

            # Add firefox privacy profile overrides
#            ".mozilla/firefox/privacy/user-overrides.js" = {
#                source = ../configs/firefox-user-overrides.js;
#                recursive = true;
#            };

            # Set firefox to privacy profile
#            ".mozilla/firefox/profiles.ini" = {
#                source = ../configs/firefox-profiles.ini;
#                recursive = true;
#            };

            # Add noise suppression microphone
            ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                source = ../configs/pipewire.conf;
                recursive = true;
            };

            # Add btop config
            ".config/btop/btop.conf" = {
                source = ../configs/btop.conf;
                recursive = true;
            };

            # Add terminator
            ".config/terminator/config" = {
                source = ../configs/terminator;
                recursive = true;
            };
        };
    };
}
