{ config, pkgs, ... }:

# Install home manager
let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
    nvidia-power-limit = "180";
    # Pstate 0, 1.25 voltage, 4200 clock speed
    zenstates-options = "-p 0 -v 30 -f A8";
in
{
    imports = [
        (import "${home-manager}/nixos")
        # Generated automatically
        ./hardware-configuration.nix
        # Disks to mount on startup
        ./mounts.nix
    ];

    home-manager.users = {
        icedborn = {
            programs = {
                git = {
                    enable = true;
                    # Git config
                    userName  = "IceDBorn";
                    userEmail = "github.envenomed@dralias.com";
                };

                alacritty = {
                    enable = true;
                    # Alacritty config
                    settings = {
                        window = {
                            # Disabled until material shell is fixed
                            #decorations = "none";
                            decorations = "full";
                        };

                        cursor.style = {
                            shape = "Underline";
                            blinking = "Always";
                        };
                    };
                };

                mangohud = {
                    enable = true;
                    # MangoHud is started on any application that supports it
                    enableSessionWide = true;
                    # Mangohud config
                    settings = {
                        background_alpha = 0;
                        cpu_color = "FFFFFF";
                        engine_color = "FFFFFF";
                        font_size = 20;
                        fps_limit = "144+60+0";
                        frame_timing = 0;
                        gl_vsync = 0;
                        gpu_color = "FFFFFF";
                        offset_x = 50;
                        position = "top-right";
                        toggle_fps_limit = "F1";
                        vsync= 1;
                        cpu_temp = "";
                        fps = "";
                        gamemode = "";
                        gpu_temp = "";
                        no_small_font = "";
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";
                };

                # Install gnome extensions using firefox
                firefox.enableGnomeExtensions = true;
            };

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
            };

            # Add desktop file for 4 terminals
            xdg.desktopEntries.startup-terminals = {
                type = "Application";
                exec =
                (
                    pkgs.writeShellScript "alacritty-exec" ''
                      alacritty &
                      alacritty &
                      alacritty &
                      alacritty &
                    ''
                ).outPath;
                icon = "Alacritty";
                terminal = false;
                categories = [ "System" "TerminalEmulator" ];
                name = "Startup Terminals";
                genericName = "Terminal";
                comment = "A fast, cross-platform, OpenGL terminal emulator";
            };

            home.file = {
                # Add zsh theme to zsh directory
                ".config/zsh/zsh-theme.sh" = {
                    source = ./scripts/zsh-theme.sh;
                    recursive = true;
                };

                # Add protondown script to zsh directory
                ".config/zsh/protondown.sh" = {
                    source = ./scripts/protondown.sh;
                    recursive = true;
                };

                # Add nvidia fan control wayland to zsh directory
                ".config/zsh/nvidia-fan-control-wayland.sh" = {
                    source = ./scripts/nvidia-fan-control-wayland.sh;
                    recursive = true;
                };

                # Add firefox privacy profile overrides
                ".mozilla/firefox/privacy/user-overrides.js" = {
                    source = ./configs/firefox-user-overrides.js;
                    recursive = true;
                };

                # Set firefox to privacy profile
                ".mozilla/firefox/profiles.ini" = {
                    source = ./configs/firefox-profiles.ini;
                    recursive = true;
                };

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ./configs/pipewire.conf;
                    recursive = true;
                };
            };
        };

        work = {
            programs = {
                git = {
                    enable = true;
                    # Git config
                    userName  = "IceDBorn";
                    userEmail = "github.envenomed@dralias.com";
                };

                alacritty = {
                    enable = true;
                    # Alacritty config
                    settings = {
                        window = {
                            # Disabled until material shell is fixed
                            #decorations = "none";
                            decorations = "full";
                            opacity = 0.8;
                        };

                        cursor.style = {
                            shape = "Underline";
                            blinking = "Always";
                        };
                    };
                };

                zsh = {
                    enable = true;
                    # Enable firefox wayland
                    profileExtra = "export MOZ_ENABLE_WAYLAND=1";
                };

                # Install gnome extensions using firefox
                firefox.enableGnomeExtensions = true;
            };

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
            };

            # Add desktop file for 4 terminals
            xdg.desktopEntries.startup-terminals = {
                type = "Application";
                exec =
                (
                    pkgs.writeShellScript "alacritty-exec" ''
                      alacritty &
                      alacritty &
                      alacritty &
                      alacritty &
                    ''
                ).outPath;
                icon = "Alacritty";
                terminal = false;
                categories = [ "System" "TerminalEmulator" ];
                name = "Startup Terminals";
                genericName = "Terminal";
                comment = "A fast, cross-platform, OpenGL terminal emulator";
            };

            home.file = {
                # Add zsh theme to zsh directory
                ".config/zsh/zsh-theme.sh" = {
                    source = ./scripts/zsh-theme.sh;
                    recursive = true;
                };

                # Add nvidia fan control wayland to zsh directory
                ".config/zsh/nvidia-fan-control-wayland.sh" = {
                    source = ./scripts/nvidia-fan-control-wayland.sh;
                    recursive = true;
                };

                # Add firefox privacy profile overrides
                ".mozilla/firefox/privacy/user-overrides.js" = {
                    source = ./configs/firefox-user-overrides.js;
                    recursive = true;
                };

                # Set firefox to privacy profile
                ".mozilla/firefox/profiles.ini" = {
                    source = ./configs/firefox-profiles.ini;
                    recursive = true;
                };

                # Add noise suppression microphone
                ".config/pipewire/pipewire.conf.d/99-input-denoising.conf" = {
                    source = ./configs/pipewire.conf;
                    recursive = true;
                };
            };
        };
    };
    
    boot = {
        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };

            systemd-boot = {
                enable = true;
                # Keep the last 10 configurations
                configurationLimit = 10;
            };
        };
        # Use Zen kernel
        kernelPackages = pkgs.linuxPackages_zen;
        # Virtual camera for OBS
        kernelModules = [ "v4l2loopback" "xpadneo" "msr" ];
    };

    networking = {
        # Define your hostname
        hostName = "nixos";
        # Enable networking
        networkmanager.enable = true;
        # Disable firewall
        firewall.enable = false;
    };

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
            videoDrivers = [ "nvidia" ];
        };

        # Enable CUPS to print documents
        printing.enable = true;

        # Enable sound with pipewire
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        # Enable SSH
        openssh.enable = true;

        gnome = {
            chrome-gnome-shell.enable = true; # Allows to install GNOME Shell extensions from a web browser
            sushi.enable = true; # Quick previewer for nautilus
        };

        # Enable flatpak
        flatpak.enable = true;

        # Enable mullvad
        mullvad-vpn.enable = true;
    };

    sound.enable = true;

    security = {
        # Required by RPCS3
        pam.loginLimits = [
            {
                domain = "*";
                type = "hard";
                item = "memlock";
                value = "2147483648";
            }

            {
                domain = "*";
                type = "soft";
                item = "memlock";
                value = "2147483648";
            }
        ];

        # Enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand
        rtkit.enable = true;

        # Show asterisks when typing sudo password
        sudo.extraConfig = "Defaults pwfeedback";
    };

    hardware = {
        # Disable pulseaudio
        pulseaudio.enable = false;
        opengl = {
            enable = true;
            # Support Direct Rendering for 32-bit applications (such as Wine) on 64-bit systems
            driSupport32Bit = true;
        };
        # Enable kernel modesetting when using the NVIDIA driver, needed for gnome wayland
        nvidia.modesetting.enable = true;
    };

    users = {
        # Set default shell to zsh
        defaultUserShell = pkgs.zsh;

        # Define users below
        users = {
            icedborn = {
                createHome = true;
                home = "/home/icedborn";
                useDefaultShell = true;
                # Default password used for first login, change later with passwd
                password = "1";
                isNormalUser = true;
                description = "IceDBorn";
                extraGroups = [ "networkmanager" "wheel" ];
                # Packages installed for this specific user only
                packages = with pkgs; [
                    android-studio # IDE for Android apps
                    bottles # Wine prefix manager
                    duckstation # PS1 Emulator
                    gamemode # Optimizations for gaming
                    godot # Game engine
                    heroic # Epic Games Launcher for Linux
                    mangohud # A metric overlay
                    pcsx2 # PS2 Emulator
                    ppsspp # PSP Emulator
                    protontricks # Winetricks for proton prefixes
                    rpcs3 # PS3 Emulator
                    ryujinx # Switch Emulator
                    scanmem # Cheat engine for linux
                    steam # Gaming platform
                ];
            };

            work = {
                createHome = true;
                home = "/home/work";
                useDefaultShell = true;
                # Default password used for first login, change later with passwd
                password = "1";
                isNormalUser = true;
                description = "Work";
                extraGroups = [ "networkmanager" "wheel" ];
                # Packages installed for this specific user only
                packages = with pkgs; [
                    # Add work specific packages here
                ];
            };
        };
    };

    nixpkgs.config = {
         # Allow proprietary packages
        allowUnfree = true;

        # Install NUR
        packageOverrides = pkgs: {
            nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
                inherit pkgs;
            };
        };
    };

    # Packages installed system-wide
    environment = {
        systemPackages = with pkgs; [
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

        # Symlink the noise suppression plugin to a regular location
        etc."rnnoise-plugin/librnnoise_ladspa.so".source = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
    };

    programs = {
        # Enable zsh and configure it
        zsh = {
            enable = true;
            # Enable oh my zsh and it's plugins
            ohMyZsh = {
                enable = true;
                plugins = [ "git" "npm" "nvm" "sudo" "systemd" ];
            };
            # Enable auto suggestions
            autosuggestions.enable = true;

            # Enable syntax highlighting
            syntaxHighlighting.enable = true;

            # Aliases
            shellAliases = {
                aria2c="aria2c -j 16 -s 16"; # Download with aria using best settings
                chmod="sudo chmod"; # It's a command that I always execute with sudo
                clear-keys="sudo rm -rf ~/ local/share/keyrings/* ~/ local/share/kwalletd/*"; # Clear system keys
                clear-proton-ge="bash ~/.config/zsh/protondown.sh"; # Download the latest proton ge version and delete the older ones
                nvidia-max-fan-speed="sudo bash ~/.config/zsh/nvidia-fan-control-wayland.sh 100"; # Maximize nvidia fan speed on wayland
                reboot-windows="(sudo grub-set-default 0) && (sudo grub-reboot 2) && (sudo reboot)"; # Reboot to windows once
                restart-pipewire="systemctl --user restart pipewire"; # Restart pipewire
                ssh="TERM=xterm-256color ssh"; # SSH with colors
                update="(sudo nixos-rebuild switch --upgrade) ; (flatpak update) ; (yes | protonup) ; (yes | ~/.mozilla/firefox/privacy/updater.sh)"; # Update everything
                vpn-off="mullvad disconnect"; # Disconnect from VPN
                vpn-on="mullvad connect"; # Connect to VPN
                vpn="mullvad status"; # Show VPN status
            };

            # Commands to run on zsh shell initialization
            interactiveShellInit = "source ~/.config/zsh/zsh-theme.sh\nunsetopt PROMPT_SP";
        };

        # Add dconf
        dconf.enable = true;
    };

    systemd.services = {
        # Ryzen cpu control
        zenstates = {
            enable = true;
            description = "Ryzen Undervolt";
            after = [ "syslog.target" "systemd-modules-load.service" ];

            unitConfig = {
                ConditionPathExists = "${pkgs.zenstates}/bin/zenstates";
            };

            serviceConfig = {
                User = "root";
                ExecStart = "${pkgs.zenstates}/bin/zenstates ${zenstates-options}";
            };

            wantedBy = [ "multi-user.target" ];
        };

        # Nvidia power limit
        nv-power-limit = {
            enable = true;
            description = "Nvidia power limit control";
            after = [ "syslog.target" "systemd-modules-load.service" ];

            unitConfig = {
                ConditionPathExists = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
            };

            serviceConfig = {
                User = "root";
                ExecStart = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi  --power-limit=${nvidia-power-limit}";
            };

            wantedBy = [ "multi-user.target" ];
        };
    };

    # Nix Package Manager settings
    nix = {
        # Nix automatically detects files in the store that have identical contents, and replaces them with hard links (makes store 3 times slower)
        settings.auto-optimise-store = true;

        # Automatic garbage collection
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
    };

    # Do not change without checking the docs
    system.stateVersion = "22.05";
}
