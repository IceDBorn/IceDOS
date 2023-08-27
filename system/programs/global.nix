# ## PACKAGES INSTALLED ON ALL USERS ###
{ pkgs, config, inputs, ... }:

let
  trim-generations = pkgs.writeShellScriptBin "trim-generations"
    (builtins.readFile ../scripts/trim-generations.sh);
  nix-gc = pkgs.writeShellScriptBin "nix-gc" ''
    gens=${config.gc.generations} ;
    days=${config.gc.days} ;
    trim-generations ''${1:-$gens} ''${2:-$days} user ;
    trim-generations ''${1:-$gens} ''${2:-$days} home-manager ;
    sudo -H -u ${config.work.user.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days user' ;
    sudo -H -u ${config.work.user.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days home-manager' ;
    sudo trim-generations ''${1:-$gens} ''${2:-$days} system ;
    nix-store --gc
  '';
  vpn-exclude = pkgs.writeShellScriptBin "vpn-exclude"
    (builtins.readFile ../scripts/create-ns.sh);
in {
  boot.kernelPackages = pkgs.linuxPackages_zen; # Use ZEN linux kernel

  environment.systemPackages = with pkgs; [
    (callPackage ./self-built/apx.nix { }) # Package manager using distrobox
    (callPackage ./self-built/webcord { }) # An open source discord client
    (firefox.override {
      extraNativeMessagingHosts =
        [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
    }) # Browser
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
    }) # Pipewire audio plugin for OBS Studio
    android-tools # Tools for debugging android devices
    appimage-run # Appimage runner
    aria # Terminal downloader with multiple connections support
    bat # Better cat command
    bless # HEX Editor
    btop # System monitor
    cargo # Rust package manager
    clamav # Antivirus
    curtail # Image compressor
    direnv # Unclutter your .profile
    dotnet-sdk_7 # SDK for .net
    easyeffects # Pipewire effects manager
    efibootmgr # Edit EFI entries
    endeavour # Tasks
    fd # Find alternative
    feh # Minimal image viewer
    gcc # C++ compiler
    gdtoolkit # Tools for gdscript
    gimp # Image editor
    git # Distributed version control system
    gping # ping with a graph
    helvum # Pipewire patchbay
    iotas # Notes
    jc # JSON parser
    jq # JSON parser
    killall # Tool to kill all programs matching process name
    kitty # Terminal
    lazygit # Git CLI UI
    libnotify # Send desktop notifications
    lsd # Better ls command
    mousai # Song recognizer
    mpv # Video player
    mullvad-vpn # VPN Client
    neovim # Terminal text editor
    newsflash # RSS reader
    nix-gc # Garbage collect old nix generations
    nixfmt # A nix formatter
    nodejs # Node package manager
    ntfs3g # Support NTFS drives
    obs-studio # Recording/Livestream
    onlyoffice-bin # Microsoft Office alternative for Linux
    p7zip # 7zip
    pulseaudio # Various pulseaudio tools
    python3 # Python
    ranger # Terminal file manager
    ripgrep # Silver searcher grep
    rnnoise-plugin # A real-time noise suppression plugin
    signal-desktop # Encrypted messaging platform
    tmux # Terminal multiplexer
    tree # Display folder content at a tree format
    trim-generations # Smarter old nix generations cleaner
    unrar # Support opening rar files
    unzip # An extraction utility
    vpn-exclude # Run shell with another gateway and IP
    vscodium # All purpose IDE
    warp # File sync
    wget # Terminal downloader
    wine # Compatibility layer capable of running Windows applications
    winetricks # Wine prefix settings manager
    woeusb # Windows ISO Burner
    xorg.xhost # Use x.org server with distrobox
    youtube-dl # Video downloader
    zenstates # Ryzen CPU controller
  ];

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

  programs = {
    zsh = {
      enable = true;
      # Enable oh my zsh and it's plugins
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "npm" "sudo" "systemd" ];
      };
      autosuggestions.enable = true;

      syntaxHighlighting.enable = true;

      # Aliases
      shellAliases = {
        apx = "apx --aur"; # Use arch as the base apx container
        aria2c = "aria2c -j 16 -s 16"; # Download with aria using best settings
        btrfs-compress =
          "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
        cat = "bat"; # Better cat command
        chmod = "sudo chmod"; # It's a command that I always execute with sudo
        clear-keys =
          "sudo rm -rf ~/ local/share/keyrings/* ~/ local/share/kwalletd/*"; # Clear system keys
        cp = "rsync -rP"; # Copy command with details
        desktop-files-list =
          "ls -l /run/current-system/sw/share/applications"; # Show desktop files location
        list-packages =
          "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
        ls = "lsd"; # Better ls command
        mva = "rsync -rP --remove-source-files"; # Move command with details
        n = "tmux a -t nvchad || tmux new -s nvchad nvim"; # Nvchad
        ping = "gping"; # ping with a graph
        reboot-windows =
          "sudo efibootmgr --bootnext ${config.boot.windows-entry} && reboot"; # Reboot to windows
        rebuild =
          "(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && bash rebuild.sh)"; # Rebuild the system configuration
        restart-pipewire =
          "systemctl --user restart pipewire"; # Restart pipewire
        server = "ssh server@192.168.1.2"; # Connect to local server
        ssh = "TERM=xterm-256color ssh"; # SSH with colors
        steam-link =
          "killall steam 2> /dev/null ; while ps axg | grep -vw grep | grep -w steam > /dev/null; do sleep 1; done && (nohup steam -pipewire > /dev/null &) 2> /dev/null"; # Kill existing steam process and relaunch steam with the pipewire flag
        update =
          "(cd $(head -1 /etc/nixos/.configuration-location) 2> /dev/null || (echo 'Configuration path is invalid. Run rebuild.sh manually to update the path!' && false) && sudo nix flake update && bash rebuild.sh) ; (apx --aur upgrade) ; (bash ~/.config/zsh/proton-ge-updater.sh) ; (bash ~/.config/zsh/steam-library-patcher.sh)"; # Update everything
        v = "nvim"; # Neovim
        vpn = "ssh -f server@192.168.1.2 'mullvad status'"; # Show VPN status
        vpn-btop = "ssh -t server@192.168.1.2 'bpytop'"; # Show VPN bpytop
        vpn-off =
          "ssh -f server@192.168.1.2 'mullvad disconnect && sleep 1 && mullvad status'"; # Disconnect from VPN
        vpn-on =
          "ssh -f server@192.168.1.2 'mullvad connect && sleep 1 && mullvad status'"; # Connect to VPN
      };

      interactiveShellInit = ''
        source ~/.config/zsh/zsh-theme.zsh
        unsetopt PROMPT_SP''; # Commands to run on zsh shell initialization
    };

    gamemode.enable = true;
  };

  services = {
    openssh.enable = true;
    mullvad-vpn.enable = true;
    clamav.updater.enable = true;
  };

  # Symlink files and folders to /etc
  environment.etc."rnnoise-plugin/librnnoise_ladspa.so".source =
    "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
  environment.etc."proton-ge-nix".source =
    "${(pkgs.callPackage self-built/proton-ge.nix { })}/";
  environment.etc."apx/config.json".source =
    "${(pkgs.callPackage self-built/apx.nix { })}/etc/apx/config.json";
}
