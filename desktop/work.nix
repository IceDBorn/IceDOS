{ config, pkgs, home-manager, ... }:

{
    home-manager.users.${config.work.user.username} = {
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

            "org/gnome/desktop/wm/preferences" = {
                # Disable application is ready notification
                focus-new-windows = "strict";
                # Set number of workspaces
                num-workspaces = 8;
            };

            # Disable mouse acceleration
            "org/gnome/desktop/peripherals/mouse" = {
                accel-profile = "flat";
            };

            # Disable file history
            "org/gnome/desktop/privacy" = {
                remember-recent-files = false;
            };

            # Disable screen lock
            "org/gnome/desktop/screensaver" = {
                lock-enabled = false;
            };

            # Disable system sounds
            "org/gnome/desktop/sound" = {
                event-sounds = false;
            };

            "org/gnome/mutter" = {
                # Enable fractional scaling
                experimental-features = [ "scale-monitor-framebuffer" ];
                # Disable dynamic workspaces
                dynamic-workspaces = false;
            };

            # Nautilus path bar is always editable
            "org/gnome/nautilus/preferences" = {
                always-use-location-entry = true;
            };

            "org/gnome/settings-daemon/plugins/power" = {
                # Disable auto suspend
                sleep-inactive-ac-type = "nothing";
                # Power button shutdown
                power-button-action = "interactive";
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
                    "emoji-selector@maestroschan.fr"
                    "gamemode@christian.kellner.me"
                    "gsconnect@andyholmes.github.io"
                    "pop-shell@system76.com"
                    "smart-auto-move@khimaros.com"
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

            # Switch to workspaces with Super + number
            "org/gnome/desktop/wm/keybindings" = {
                switch-to-workspace-1 = [ "<Super>1" ];
                switch-to-workspace-2 = [ "<Super>2" ];
                switch-to-workspace-3 = [ "<Super>3" ];
                switch-to-workspace-4 = [ "<Super>4" ];
                switch-to-workspace-5 = [ "<Super>5" ];
                switch-to-workspace-6 = [ "<Super>6" ];
                switch-to-workspace-7 = [ "<Super>7" ];
                switch-to-workspace-8 = [ "<Super>8" ];
                switch-to-workspace-9 = [ "<Super>9" ];
                switch-to-workspace-10 = [ "<Super>0" ];
            };

            # Limit app switcher to current workspace
            "org/gnome/shell/app-switcher" = {
                current-workspace-only = true;
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

            "org/gnome/shell/extensions/smart-auto-move" = {
                sync-mode = "IGNORE";
                overrides = ''{"firefox":[{"action":1,"threshold":0.7}],"":[{"query":{"title":"home.nix - arch-linux-setup - VSCodium"},"action":1}],"jetbrains-studio":[{"action":1,"threshold":0.7}],"signal":[{"action":1,"threshold":0.7}],"de.shorsh.discord-screenaudio":[{"action":1,"threshold":0.7}],"heroic":[{"action":1,"threshold":0.7}],"Steam":[{"threshold":0.7,"action":1}],"bottles":[{"action":1,"threshold":0.7}],"kitty":[{"action":1,"threshold":0.7}],"org.gnome.Nautilus":[{"action":1,"threshold":0.7}],".system-monitoring-center-wrapped":[{"action":1,"threshold":0.7}]}'';
            };

            "org/gnome/shell/extensions/pop-shell" = {
                gap-inner = 0;
                gap-outer = 0;
                tile-by-default = true;
            };

            # Always hide tray icons
            "org/gnome/shell/extensions/trayIconsReloaded" = {
                icons-limit = 1;
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

            # Add hyprland config
            ".config/hypr/hyprland.conf" = {
                source = ../configs/hyprland.conf;
                recursive = true;
            };

            # Add waybar configs
            ".config/waybar/config" = {
                source = ../configs/waybar/config;
                recursive = true;
            };

            ".config/waybar/style.css" = {
                source = ../configs/waybar/style.css;
                recursive = true;
            };
        };
    };
}