{ config, pkgs, home-manager, ... }:

{
    home-manager.users = {
        ${config.main.user.username} = {
            dconf.settings = {
                "org/gnome/desktop/interface" = {
                    # Enable dark mode
                    color-scheme = "prefer-dark";
                    # Change icon theme
                    icon-theme = "Tela-black-dark";
                    # Change gtk theme
                    gtk-theme = "Adwaita-dark";
                    # Change cursor theme
                    cursor-theme = "Bibata-Modern-Classic";
                    # Enable clock seconds
                    clock-show-seconds = true;
                };

                # Disable lockscreen notifications
                "org/gnome/desktop/notifications" = {
                    show-in-lock-screen = false;
                };

                "org/gnome/desktop/wm/preferences" = {
                    # Disable application is ready notification
                    focus-new-windows = "strict";
                    # Set number of workspaces
                    num-workspaces = 1;
                };

                # Disable mouse acceleration
                "org/gnome/desktop/peripherals/mouse" = {
                    accel-profile = "flat";
                };

                # Disable file history
                "org/gnome/desktop/privacy" = {
                    remember-recent-files = false;
                };

                # Disable system sounds
                "org/gnome/desktop/sound" = {
                    event-sounds = false;
                };

                # Enable fractional scaling
                "org/gnome/mutter" = {
                    experimental-features = [ "scale-monitor-framebuffer" ];
                    # Disable dynamic workspaces
                    dynamic-workspaces = false;
                };

                # Nautilus path bar is always editable
                "org/gnome/nautilus/preferences" = {
                    always-use-location-entry = true;
                };

                "org/gnome/shell" = {
                    # Enable gnome extensions
                    disable-user-extensions = false;
                    # Set enabled gnome extensions
                    enabled-extensions =
                    [
                        "arcmenu@arcmenu.com"
                        "bluetooth-quick-connect@bjarosze.gmail.com"
                        "clipboard-indicator@tudmotu.com"
                        "color-picker@tuberry"
                        "dash-to-panel@jderose9.github.com"
                        "emoji-selector@maestroschan.fr"
                        "gamemode@christian.kellner.me"
                        "gsconnect@andyholmes.github.io"
                        "sound-output-device-chooser@kgshank.net"
                        "trayIconsReloaded@selfmade.pl"
                        "volume-mixer@evermiss.net"
                    ];
                };

                "org/gnome/shell/keybindings" = {
                    # Disable switch to application shortcuts
                    switch-to-application-1 = [];
                    switch-to-application-2 = [];
                    switch-to-application-3 = [];
                    switch-to-application-4 = [];
                    switch-to-application-5 = [];
                    switch-to-application-6 = [];
                    switch-to-application-7 = [];
                    switch-to-application-8 = [];
                    switch-to-application-9 = [];
                    # Disable clock shortcut
                    toggle-message-tray = [];
                };

                # Limit app switcher to current workspace
                "org/gnome/shell/app-switcher" = {
                    current-workspace-only = true;
                };

                "org/gnome/shell/extensions/clipboard-indicator" = {
                    # Remove whitespace before and after the text
                    strip-text = true;
                    # Open the extension with Super + V
                    toggle-menu = [ "<Super>v" ];
                };

                # Disable color picker notifications
                "org/gnome/shell/extensions/color-picker" = {
                    enable-notify = false;
                };

                # Do not always show emoji selector
                "org/gnome/shell/extensions/emoji-selector" = {
                    always-show = false;
                };

                "org/gnome/shell/extensions/sound-output-device-chooser" = {
                    # Add an arrow to expand devices
                    integrate-with-slider = true;
                    # Hide arrow when there's only one device to choose from
                    hide-on-single-device = true;
                };

                # Always hide tray icons
                "org/gnome/shell/extensions/trayIconsReloaded" = {
                    icons-limit = 10;
                };
            };

            # Force vscodium to use wayland
            xdg.desktopEntries.codium = {
                type = "Application";
                exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
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
                exec = "signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %U";
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

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ../configs/pipewire.conf;
                    recursive = true;
                };

                # Add discord-screenaudio to startup
                ".config/autostart/de.shorsh.discord-screenaudio.desktop" = {
                    source = ../startup/de.shorsh.discord-screenaudio.desktop;
                    recursive = true;
                };

                # Add mullvad vpn to startup
                ".config/autostart/mullvad-vpn.desktop" = {
                    text = ''
                        [Desktop Entry]
                        Name=mullvad-vpn
                        Exec=${pkgs.mullvad-vpn}/bin/mullvad-vpn --no-sandbox --disable-gpu
                        Terminal=false
                        Type=Application
                        Icon=mullvad-vpn
                        StartupWMClass=mullvad-vpn
                        Comment=Mullvad VPN client
                        Categories=Network;
                    '';
                    recursive = true;
                };

                # Add signal to startup
                ".config/autostart/signal-desktop.desktop" = {
                    source = ../startup/signal-desktop.desktop;
                    recursive = true;
                };

                # Add steam to startup
                ".config/autostart/steam.desktop" = {
                    source = ../startup/steam.desktop;
                    recursive = true;
                };
            };
        };

        ${config.work.user.username} = {
            dconf.settings = {
                "org/gnome/desktop/interface" = {
                    # Enable dark mode
                    color-scheme = "prefer-dark";
                    # Change icon theme
                    icon-theme = "Tela-black-dark";
                    # Change gtk theme
                    gtk-theme = "Adwaita-dark";
                    # Change cursor theme
                    cursor-theme = "Bibata-Modern-Classic";
                    # Enable clock seconds
                    clock-show-seconds = true;
                    # Disable date
                    clock-show-date = false;
                };

                # Disable lockscreen notifications
                "org/gnome/desktop/notifications" = {
                    show-in-lock-screen = false;
                };

                # Disable application is ready notification
                "org/gnome/desktop/wm/preferences" = {
                    focus-new-windows = "strict";
                    # Set number of workspaces
                    num-workspaces = 1;
                };

                # Disable mouse acceleration
                "org/gnome/desktop/peripherals/mouse" = {
                    accel-profile = "flat";
                };

                # Disable file history
                "org/gnome/desktop/privacy" = {
                    remember-recent-files = false;
                };

                # Disable system sounds
                "org/gnome/desktop/sound" = {
                    event-sounds = false;
                };

                # Enable fractional scaling
                "org/gnome/mutter" = {
                    experimental-features = [ "scale-monitor-framebuffer" ];
                    # Disable dynamic workspaces
                    dynamic-workspaces = false;
                };

                # Nautilus path bar is always editable
                "org/gnome/nautilus/preferences" = {
                    always-use-location-entry = true;
                };

                "org/gnome/shell" = {
                    # Enable gnome extensions
                    disable-user-extensions = false;
                    # Set enabled gnome extensions
                    enabled-extensions =
                    [
                        "arcmenu@arcmenu.com"
                        "bluetooth-quick-connect@bjarosze.gmail.com"
                        "clipboard-indicator@tudmotu.com"
                        "color-picker@tuberry"
                        "dash-to-panel@jderose9.github.com"
                        "emoji-selector@maestroschan.fr"
                        "gamemode@christian.kellner.me"
                        "gsconnect@andyholmes.github.io"
                        "sound-output-device-chooser@kgshank.net"
                        "trayIconsReloaded@selfmade.pl"
                        "volume-mixer@evermiss.net"
                    ];
                };

                # Limit app switcher to current workspace
                "org/gnome/shell/app-switcher" = {
                    current-workspace-only = true;
                };

                "org/gnome/shell/extensions/clipboard-indicator" = {
                    # Remove whitespace before and after the text
                    strip-text = true;
                    # Open the extension with Super + V
                    toggle-menu = [ "<Super>v" ];
                };

                # Disable color picker notifications
                "org/gnome/shell/extensions/color-picker" = {
                    enable-notify = false;
                };

                # Do not always show emoji selector
                "org/gnome/shell/extensions/emoji-selector" = {
                    always-show = false;
                };

                "org/gnome/shell/extensions/sound-output-device-chooser" = {
                    # Add an arrow to expand devices
                    integrate-with-slider = true;
                    # Hide arrow when there's only one device to choose from
                    hide-on-single-device = true;
                };

                # Always hide tray icons
                "org/gnome/shell/extensions/trayIconsReloaded" = {
                    icons-limit = 10;
                };
            };

            # Force vscodium to use wayland
            xdg.desktopEntries.codium = {
                type = "Application";
                exec = "codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
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

            home.file = {
                # Add zsh theme to zsh directory
                ".config/zsh/zsh-theme.zsh" = {
                    source = ../configs/zsh-theme.zsh;
                    recursive = true;
                };

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ../configs/pipewire.conf;
                    recursive = true;
                };

                # Add discord-screenaudio to startup
                ".config/autostart/de.shorsh.discord-screenaudio.desktop" = {
                    source = ../startup/de.shorsh.discord-screenaudio.desktop;
                    recursive = true;
                };

                 # Add terminator
                ".config/terminator/config" = {
                    source = ../configs/terminator;
                    recursive = true;
                };
            };
        };
    };
}
