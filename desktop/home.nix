{ config, pkgs, home-manager, ... }:

{
    home-manager.users = {
        ${config.main.user.username} = {
            dconf.settings = {
                # Nautilus path bar is always editable
                "org/gnome/nautilus/preferences" = {
                    always-use-location-entry = true;
                };

                # Enable fractional scaling
                "org/gnome/mutter" = {
                    experimental-features = [ "scale-monitor-framebuffer" ];
                };

                "org/gnome/shell" = {
                    # Enable gnome extensions
                    disable-user-extensions = false;
                    # Set enabled gnome extensions
                    enabled-extensions =
                    [
                        "bluetooth-quick-connect@bjarosze.gmail.com"
                        "caffeine@patapon.info"
                        "clipboard-indicator@tudmotu.com"
                        "color-picker@tuberry"
                        "gamemode@christian.kellner.me"
                        "gsconnect@andyholmes.github.io"
                        "sound-output-device-chooser@kgshank.net"
                        "trayIconsReloaded@selfmade.pl"
                        "volume-mixer@evermiss.net"
                    ];
                };

                "org/gnome/desktop/interface" = {
                    # Enable dark mode
                    color-scheme = "prefer-dark";
                    # Change icon theme
                    icon-theme = "Tela-black-dark";
                    # Change gtk theme
                    gtk-theme = "Plata-Noir-Compact";
                    # Change cursor theme
                    cursor-theme = "Bibata-Modern-Classic";
                };

                # Disable system sounds
                "org/gnome/desktop/sound" = {
                    event-sounds = false;
                };

                # Disable lockscreen notifications
                "org/gnome/desktop/notifications" = {
                    show-in-lock-screen = false;
                };

                # Limit app switcher to current workspace
                "org/gnome/shell/app-switcher" = {
                    current-workspace-only = true;
                };

                # Disable file history
                "org/gnome/desktop/privacy" = {
                    remember-recent-files = false;
                };

                # Disable screen lock
                "org/gnome/desktop/screensaver" = {
                    lock-enabled = false;
                };

                "org/gnome/settings-daemon/plugins/power" = {
                    # Disable auto suspend
                    sleep-inactive-ac-type = "nothing";
                    # Power button shutdown
                    power-button-action = "interactive";
                };

                # Always hide tray icons
                "org/gnome/shell/extensions/trayIconsReloaded" = {
                    icons-limit = 1;
                };
                
                "org/gnome/shell/extensions/sound-output-device-chooser" = {
                    # Add an arrow to expand devices
                    integrate-with-slider = true;
                    # Hide arrow when there's only one device to choose from
                    hide-on-single-device = true;
                };

                "org/gnome/shell/extensions/color-picker" = {
                    # Disable color picker notifications
                    enable-notify = false;
                };

                "org/gnome/shell/extensions/clipboard-indicator" = {
                    # Remove whitespace before and after the text
                    strip-text = true;
                    # Open the extension with Super + V
                    toggle-menu = [ "<Super>v" ];
                };

                "org/gnome/shell/extensions/caffeine" = {
                    # Remember the user choice
                    restore-state = true;
                    # Disable icon
                    show-indicator = false;
                    # Disable auto suspend and lock
                    user-enabled = true;
                    # Disable notifications
                    show-notifications = false;
                };
            };

            # Add desktop file for 4 terminals
            xdg.desktopEntries.startup-terminals = {
                type = "Application";
                exec =
                (
                    pkgs.writeShellScript "alacritty-exec" ''
                      kitty &
                      kitty &
                      kitty &
                      kitty &
                    ''
                ).outPath;
                icon = "Kitty";
                terminal = false;
                categories = [ "System" "TerminalEmulator" ];
                name = "Startup Terminals";
                genericName = "Terminal";
                comment = "A fast, cross-platform, OpenGL terminal emulator";
            };

            # Force vscodium to use wayland
            xdg.desktopEntries.codium = {
                type = "Application";
                exec = "codium --enable-features=UseOzonePlatform --ozone-platform=wayland %F";
                icon = "code";
                terminal = false;
                categories = [ "Utility" "TextEditor" "Development" "IDE" ];
                name = "VSCodium";
                genericName = "Text Editor";
                comment = "Code Editing. Redefined.";
                actions.new-empty-window = {
                    "exec" = "codium --new-window %F";
                    "icon" = "code";
                    "name" = "New Empty Window";
                };
            };

            # Force signal to use wayland
            xdg.desktopEntries.signal-desktop = {
                type = "Application";
                exec = "signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
                icon = "signal-desktop";
                terminal = false;
                categories = [ "Network" "InstantMessaging" "Chat" ];
                name = "Signal";
                genericName = "Text Editor";
                comment = "Private messaging from your desktop";
                actions.new-empty-window = {
                    "exec" = "codium --new-window %F";
                    "icon" = "code";
                    "name" = "New Empty Window";
                };
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

                # Add nvidia fan control wayland to zsh directory
                ".config/zsh/nvidia-fan-control-wayland.sh" = {
                    source = ../scripts/nvidia-fan-control-wayland.sh;
                    recursive = true;
                };

                # Add firefox privacy profile overrides
                ".mozilla/firefox/privacy/user-overrides.js" = {
                    source = ../configs/firefox-user-overrides.js;
                    recursive = true;
                };

                # Set firefox to privacy profile
                ".mozilla/firefox/profiles.ini" = {
                    source = ../configs/firefox-profiles.ini;
                    recursive = true;
                };

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ../configs/pipewire.conf;
                    recursive = true;
                };
            };
        };

        ${config.work.user.username} = {
            dconf.settings = {
                # Nautilus path bar is always editable
                "org/gnome/nautilus/preferences" = {
                    always-use-location-entry = true;
                };

                # Enable fractional scaling
                "org/gnome/mutter" = {
                    experimental-features = [ "scale-monitor-framebuffer" ];
                };

                "org/gnome/shell" = {
                    # Enable gnome extensions
                    disable-user-extensions = false;
                    # Set enabled gnome extensions
                    enabled-extensions =
                    [
                        "CoverflowAltTab@palatis.blogspot.com"
                        "bluetooth-quick-connect@bjarosze.gmail.com"
                        "clipboard-indicator@tudmotu.com"
                        "color-picker@tuberry"
                        "gamemode@christian.kellner.me"
                        "gsconnect@andyholmes.github.io"
                        # Material shell crashes the gnome desktop
                        #"material-shell@papyelgringo"
                        "sound-output-device-chooser@kgshank.net"
                        "trayIconsReloaded@selfmade.pl"
                        "volume-mixer@evermiss.net"
                    ];
                };

                "org/gnome/desktop/interface" = {
                    # Enable dark mode
                    color-scheme = "prefer-dark";
                    # Change icon theme
                    icon-theme = "Tela-black-dark";
                    # Change gtk theme
                    gtk-theme = "Plata-Noir-Compact";
                    # Change cursor theme
                    cursor-theme = "Bibata-Modern-Classic";
                };

                # Disable system sounds
                "org/gnome/desktop/sound" = {
                    event-sounds = false;
                };

                # Disable lockscreen notifications
                "org/gnome/desktop/notifications" = {
                    show-in-lock-screen = false;
                };

                # Limit app switcher to current workspace
                "org/gnome/shell/app-switcher" = {
                    current-workspace-only = true;
                };

                # Disable file history
                "org/gnome/desktop/privacy" = {
                    remember-recent-files = false;
                };

                # Disable screen lock
                "org/gnome/desktop/screensaver" = {
                    lock-enabled = false;
                };

                "org/gnome/settings-daemon/plugins/power" = {
                    # Disable auto suspend
                    sleep-inactive-ac-type = "nothing";
                    # Power button shutdown
                    power-button-action = "interactive";
                };

                # Always hide tray icons
                "org/gnome/shell/extensions/trayIconsReloaded" = {
                    icons-limit = 1;
                };
                
                "org/gnome/shell/extensions/sound-output-device-chooser" = {
                    # Add an arrow to expand devices
                    integrate-with-slider = true;
                    # Hide arrow when there's only one device to choose from
                    hide-on-single-device = true;
                };

                "org/gnome/shell/extensions/color-picker" = {
                    # Disable color picker notifications
                    enable-notify = false;
                };

                "org/gnome/shell/extensions/clipboard-indicator" = {
                    # Remove whitespace before and after the text
                    strip-text = true;
                    # Open the extension with Super + V
                    toggle-menu = [ "<Super>v" ];
                };

                "org/gnome/shell/extensions/caffeine" = {
                    # Remember the user choice
                    restore-state = true;
                    # Disable icon
                    show-indicator = false;
                    # Disable auto suspend and lock
                    user-enabled = true;
                    # Disable notifications
                    show-notifications = false;
                };
            };

            # Add desktop file for 4 terminals
            xdg.desktopEntries.startup-terminals = {
                type = "Application";
                exec =
                (
                    pkgs.writeShellScript "alacritty-exec" ''
                      kitty &
                      kitty &
                      kitty &
                      kitty &
                    ''
                ).outPath;
                icon = "Kitty";
                terminal = false;
                categories = [ "System" "TerminalEmulator" ];
                name = "Startup Terminals";
                genericName = "Terminal";
                comment = "A fast, cross-platform, OpenGL terminal emulator";
            };

            # Force vscodium to use wayland
            xdg.desktopEntries.codium = {
                type = "Application";
                exec = "codium --enable-features=UseOzonePlatform --ozone-platform=wayland %F";
                icon = "code";
                terminal = false;
                categories = [ "Utility" "TextEditor" "Development" "IDE" ];
                name = "VSCodium";
                genericName = "Text Editor";
                comment = "Code Editing. Redefined.";
                actions.new-empty-window = {
                    "exec" = "codium --new-window %F";
                    "icon" = "code";
                    "name" = "New Empty Window";
                };
            };

            # Force signal to use wayland
            xdg.desktopEntries.signal-desktop = {
                type = "Application";
                exec = "signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
                icon = "signal-desktop";
                terminal = false;
                categories = [ "Network" "InstantMessaging" "Chat" ];
                name = "Signal";
                genericName = "Text Editor";
                comment = "Private messaging from your desktop";
                actions.new-empty-window = {
                    "exec" = "codium --new-window %F";
                    "icon" = "code";
                    "name" = "New Empty Window";
                };
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

                # Add nvidia fan control wayland to zsh directory
                ".config/zsh/nvidia-fan-control-wayland.sh" = {
                    source = ../scripts/nvidia-fan-control-wayland.sh;
                    recursive = true;
                };

                # Add firefox privacy profile overrides
                ".mozilla/firefox/privacy/user-overrides.js" = {
                    source = ../configs/firefox-user-overrides.js;
                    recursive = true;
                };

                # Set firefox to privacy profile
                ".mozilla/firefox/profiles.ini" = {
                    source = ../configs/firefox-profiles.ini;
                    recursive = true;
                };

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ../configs/pipewire.conf;
                    recursive = true;
                };
            };
        };
    };
}
