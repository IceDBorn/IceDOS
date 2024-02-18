# PACKAGES INSTALLED ON ALL USERS
{ pkgs, config, inputs, lib, ... }:

let
  # Logout from any shell
  lout = pkgs.writeShellScriptBin "lout" ''
    pkill -KILL -u $USER
  '';

  # Garbage collect the nix store
  nix-gc = pkgs.writeShellScriptBin "nix-gc" ''
    gens=${config.system.gc.generations} ;
    days=${config.system.gc.days} ;
    trim-generations ''${1:-$gens} ''${2:-$days} user ;
    trim-generations ''${1:-$gens} ''${2:-$days} home-manager ;
    sudo -H -u ${config.system.user.work.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days user' ;
    sudo -H -u ${config.system.user.work.username} env Gens="''${1:-$gens}" Days="''${2:-$days}" bash -c 'trim-generations $Gens $Days home-manager' ;
    sudo trim-generations ''${1:-$gens} ''${2:-$days} system ;
    nix-store --gc
  '';

  rebuild = import modules/rebuild.nix {
    inherit pkgs config;
    command = "rebuild";
    update = "false";
    stash = "false";
  };

  update-codium-extensions =
    import modules/codium-extension-updater.nix { inherit pkgs; };

  # Trim NixOS generations
  trim-generations = pkgs.writeShellScriptBin "trim-generations"
    (builtins.readFile ../scripts/trim-generations.sh);

  codingDeps = with pkgs; [
    bruno # API explorer
    cargo # Rust package manager
    dotnet-sdk_7 # SDK for .net
    gcc # C++ compiler
    gdtoolkit # Tools for gdscript
    gnumake # A tool to control the generation of non-source files from sources
    nixfmt # A nix formatter
    nodejs # Node package manager
    python3 # Python
    vscodium # All purpose IDE
  ];

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  nvchadDeps = with pkgs; [
    beautysh # Bash formatter
    black # Python formatter
    lazygit # Git CLI UI
    libclang # C language server and formatter
    lua-language-server # Lua language server
    marksman # Markdown language server
    neovim # Terminal text editor
    nil # Nix language server
    nodePackages.bash-language-server # Bash Language server
    nodePackages.dockerfile-language-server-nodejs # Dockerfiles language server
    nodePackages.eslint # An AST-based pattern checker for JavaScript
    nodePackages.intelephense # PHP language server
    nodePackages.prettier # Javascript/Typescript formatter
    nodePackages.typescript-language-server # Typescript language server
    nodePackages.vscode-langservers-extracted # HTML, CSS, Eslint, Json language servers
    phpPackages.phpstan # PHP Static Analysis Tool
    python3Packages.jedi-language-server # Python language server
    ripgrep # Silver searcher grep
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    shellcheck # Shell script analysis tool
    stylua # Lua formatter
    tailwindcss-language-server # Tailwind language server
    tree-sitter # Parser generator tool and an incremental parsing library
  ];

  packageOverrides = with pkgs;
    [
      # Browser with pipewire-screenaudio connector json
      (firefox.override {
        nativeMessagingHosts =
          [ inputs.pipewire-screenaudio.packages.${pkgs.system}.default ];
      })
    ];

  packageWraps = with pkgs;
    [
      # Pipewire audio plugin for OBS Studio
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
      })
    ];

  shellScripts = [
    inputs.shell-in-netns.packages.${pkgs.system}.default
    lout
    nix-gc
    rebuild
    trim-generations
    update-codium-extensions
  ];
in {
  boot.kernelPackages = lib.mkIf (!config.applications.steam.session.steamdeck
    && builtins.pathExists /etc/icedos-version)
    pkgs.linuxPackages_cachyos; # Use CachyOS optimized linux kernel

  environment.systemPackages = with pkgs;
    [
      android-tools # Tools for debugging android devices
      appimage-run # Appimage runner
      aria # Terminal downloader with multiple connections support
      bat # Better cat command
      bless # HEX Editor
      btop # System monitor
      clamav # Antivirus
      curtail # Image compressor
      easyeffects # Pipewire effects manager
      efibootmgr # Edit EFI entries
      endeavour # Tasks
      fd # Find alternative
      flowblade # Video editor
      fragments # Bittorrent client following Gnome UI standards
      gimp # Image editor
      gnome.gnome-boxes # VM manager
      gping # ping with a graph
      gthumb # Image viewer
      helvum # Pipewire patchbay
      iotas # Notes
      jc # JSON parser
      jq # JSON parser
      killall # Tool to kill all programs matching process name
      kitty # Terminal
      libnotify # Send desktop notifications
      logseq # Note taking with nodes
      lsd # Better ls command
      mission-center # Task manager
      moonlight-qt # Remote streaming
      mousai # Song recognizer
      mpv # Video player
      ncdu # Terminal disk analyzer
      newsflash # RSS reader
      nix-health # Check system health
      ntfs3g # Support NTFS drives
      obs-studio # Recording/Livestream
      onlyoffice-bin # Microsoft Office alternative for Linux
      p7zip # 7zip
      pavucontrol # Sound manager
      ranger # Terminal file manager
      rnnoise-plugin # A real-time noise suppression plugin
      scrcpy # Remotely use android
      signal-desktop # Encrypted messaging platform
      solaar # Logitech devices manager
      sunshine # Remote desktop
      tailscale # VPN with P2P support
      tmux # Terminal multiplexer
      trayscale # Tailscale GUI
      tree # Display folder content at a tree format
      unrar # Support opening rar files
      unzip # An extraction utility
      warp # File sync
      wget # Terminal downloader
      wine # Compatibility layer capable of running Windows applications
      winetricks # Wine prefix settings manager
      woeusb # Windows ISO Burner
      xorg.xhost # Use x.org server with distrobox
      youtube-dl # Video downloader
      zenstates # Ryzen CPU controller
    ] ++ codingDeps ++ nvchadDeps ++ myPackages ++ packageOverrides
    ++ packageWraps ++ shellScripts;

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

  programs = {
    direnv.enable = true;

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
        aria2c = "aria2c -j 16 -s 16"; # Download with aria using best settings
        btrfs-compress =
          "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
        cat = "bat"; # Better cat command
        cp = "rsync -rP"; # Copy command with details
        list-packages =
          "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
        ls = "lsd"; # Better ls command
        mva = "rsync -rP --remove-source-files"; # Move command with details
        n = "tmux a -t nvchad || tmux new -s nvchad nvim"; # Nvchad
        ping = "gping"; # ping with a graph
        reboot-windows =
          "sudo efibootmgr --bootnext ${config.boot.windowsEntry} && reboot"; # Reboot to windows
        repair-store =
          "nix-store --verify --check-contents --repair"; # Verifies integrity and repairs inconsistencies between Nix database and store
        restart-pipewire =
          "systemctl --user restart pipewire"; # Restart pipewire
        ssh = "TERM=xterm-256color ssh"; # SSH with colors
        v = "nvim"; # Neovim
      };

      # Commands to run on zsh shell initialization
      interactiveShellInit = ''
        source ~/.config/zsh/zsh-theme.zsh
        export EDITOR=nvim
        unsetopt PROMPT_SP'';
    };

    # Enable gamemode and set custom settings
    gamemode = {
      enable = true;
      settings = {
        general.renice = 20;
        gpu = {
          apply_gpu_optimisations = 1;
          nv_powermizer_mode = 1;
          amd_performance_level = "high";
        };
      };
    };
  };

  security.wrappers = {
    sunshine = {
      owner = "root";
      group = "root";
      source = "${pkgs.sunshine}/bin/sunshine";
      capabilities = "cap_sys_admin+p";
    };
  };

  services = {
    clamav.updater.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    udev.packages = with pkgs; [
      (writeTextFile {
        name = "sunshine_udev";
        text = ''
          KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/85-sunshine.rules";
      }) # Needed for sunshine input to work
      logitech-udev-rules # Needed for solaar to work
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/applications/video/mpv/scripts
        scripts = [
          pkgs.mpvScripts.mpris # Allow control with standard media keys
          pkgs.mpvScripts.thumbfast # Thumbnailer
          pkgs.mpvScripts.uosc # Feature-rich minimalist proximity-based UI
        ] ++ lib.optional config.desktop.gnome.enable
          pkgs.mpvScripts.inhibit-gnome; # Prevent gnome screen blanking while playing media
      };
    })
  ];

  # Symlink files and folders to /etc
  environment.etc."rnnoise-plugin/librnnoise_ladspa.so".source =
    "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
}
