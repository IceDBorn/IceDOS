### PACKAGES INSTALLED ON ALL USERS ###
{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        alacritty # Terminal
        android-tools # Tools for debugging android devices
        aria # Terminal downloader with multiple connections support
        btop # Terminal system monitor
        firefox # Browser
        flatpak # Source for more applications
        gimp # Image editor
        git # Distributed version control system
        helvum # Pipewire patchbay
        jetbrains.webstorm # All purpose IDE
        mullvad-vpn # VPN Client
        ntfs3g # Support NTFS drives
        obs-studio # Recording/Livestream
        onlyoffice-bin # Microsoft Office alternative for Linux
        ranger # Terminal file manager
        rnnoise-plugin # A real-time noise suppression plugin
        signal-desktop # Encrypted messaging platform
        sublime4 # Text editor
        syncthing # Local file sync
        tree # Display folder content at a tree format
        unrar # Support opening rar files
        usbimager # ISO Burner
        wget # Terminal downloader
        wine # Compatibility layer capable of running Windows applications
        winetricks # Wine prefix settings manager
        woeusb # Windows ISO Burner
        zenstates # Ryzen CPU controller
    ];

    # ZSH configuration
    programs.zsh = {
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