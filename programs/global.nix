### PACKAGES INSTALLED ON ALL USERS ###
{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        android-tools # Tools for debugging android devices
        aria # Terminal downloader with multiple connections support
        firefox # Browser
        flatpak # Source for more applications
        gimp # Image editor
        git # Distributed version control system
        helvum # Pipewire patchbay
        jetbrains-mono # A monospace typeface made for developers
        kitty # Terminal
        mullvad-vpn # VPN Client
        ntfs3g # Support NTFS drives
        obs-studio # Recording/Livestream
        onlyoffice-bin # Microsoft Office alternative for Linux
        rnnoise-plugin # A real-time noise suppression plugin
        signal-desktop # Encrypted messaging platform
        sublime4 # Text editor
        tree # Display folder content at a tree format
        unrar # Support opening rar files
        usbimager # ISO Burner
        vscodium # All purpose IDE
        jetbrains.webstorm # Javascript IDE
        wget # Terminal downloader
        wine # Compatibility layer capable of running Windows applications
        winetricks # Wine prefix settings manager
        woeusb # Windows ISO Burner
        zenstates # Ryzen CPU controller
    ];

    # ZSH configuration
    programs = {
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
                desktop-files-list="ls -l /run/current-system/sw/share/applications"; # Show desktop files location
                nvidia-max-fan-speed="sudo bash ~/.config/zsh/nvidia-fan-control-wayland.sh 100"; # Maximize nvidia fan speed on wayland
                restart-pipewire="systemctl --user restart pipewire"; # Restart pipewire
                ssh="TERM=xterm-256color ssh"; # SSH with colors
                sunshine="cd /home/${config.main.user.username}/.config/zsh/nvidia-patch && git pull && sudo bash patch-fbc.sh -f && export PULSE_SERVER=/run/user/1000/pulse/native && flatpak run dev.lizardbyte.sunshine"; # Flatpak sunshine with sound
                update="(sudo nixos-rebuild switch --upgrade) ; (flatpak update) ; (yes | protonup)"; # Update everything
                vpn-off="mullvad disconnect"; # Disconnect from VPN
                vpn-on="mullvad connect"; # Connect to VPN
                vpn="mullvad status"; # Show VPN status
            };

            # Commands to run on zsh shell initialization
            interactiveShellInit = "source ~/.config/zsh/zsh-theme.zsh\nunsetopt PROMPT_SP";
        };

        # Enable gamemode
        gamemode.enable = true;
    };

    # Program services
    services = {
        # Enable SSH
        openssh.enable = true;

        # Enable flatpak
        flatpak.enable = true;

        # Enable mullvad
        mullvad-vpn.enable = true;
    };

    # Symlink files from store needed for applications or config files
    environment.etc = {
        "rnnoise-plugin/librnnoise_ladspa.so".source = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
        "bibata-cursors".source = "${pkgs.bibata-cursors}/share/icons";
    };
}
