{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos;

  # Logout from any shell
  lout = pkgs.writeShellScriptBin "lout" ''
    pkill -KILL -u $USER
  '';

  # Garbage collect the nix store
  nix-gc = import modules/nix-gc.nix { inherit config lib pkgs; };

  rebuild = import modules/rebuild.nix {
    inherit pkgs config;
    command = "rebuild";
    update = "false";
  };

  toggle-services = import modules/toggle-services.nix { inherit pkgs; };

  # Trim NixOS generations
  trim-generations = pkgs.writeShellScriptBin "trim-generations" (
    builtins.readFile ../../scripts/trim-generations.sh
  );

  codingDeps = with pkgs; [
    bruno # API explorer
    cargo # Rust package manager
    dotnet-sdk_7 # SDK for .net
    gcc # C++ compiler
    gdtoolkit # Tools for gdscript
    gnumake # A tool to control the generation of non-source files from sources
    nixfmt-rfc-style # A nix formatter
    nodejs # Node package manager
    python3 # Python
  ];

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  packageWraps = with pkgs; [
    # Pipewire audio plugin for OBS Studio
    (pkgs.wrapOBS { plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ]; })
  ];

  shellScripts = [
    inputs.shell-in-netns.packages.${pkgs.system}.default
    lout
    nix-gc
    rebuild
    toggle-services
    trim-generations
  ];
in
{
  imports = [ configs/pipewire.nix ];

  boot.kernelPackages = mkIf (
    !cfg.hardware.steamdeck && builtins.pathExists /etc/icedos-version
  ) pkgs.linuxPackages_cachyos; # Use CachyOS optimized linux kernel

  environment.systemPackages =
    with pkgs;
    [
      appimage-run # Appimage runner
      aria # Terminal downloader with multiple connections support
      brave # Secondary browser
      bat # Better cat command
      bless # HEX Editor
      btop # System monitor
      celluloid # Video player
      clamav # Antivirus
      curtail # Image compressor
      easyeffects # Pipewire effects manager
      efibootmgr # Edit EFI entries
      endeavour # Tasks
      fd # Find alternative
      flowblade # Video editor
      fragments # Bittorrent client following Gnome UI standards
      gimp # Image editor
      gping # ping with a graph
      gthumb # Image viewer
      helvum # Pipewire patchbay
      iotas # Notes
      jc # JSON parser
      jq # JSON parser
      killall # Tool to kill all programs matching process name
      kitty # Terminal
      logseq # Note taking with nodes
      lsd # Better ls command
      mission-center # Task manager
      moonlight-qt # Remote streaming
      mousai # Song recognizer
      ncdu # Terminal disk analyzer
      newsflash # RSS reader
      nix-health # Check system health
      ntfs3g # Support NTFS drives
      obs-studio # Recording/Livestream
      onlyoffice-bin # Microsoft Office alternative for Linux
      p7zip # 7zip
      pavucontrol # Sound manager
      rnnoise-plugin # A real-time noise suppression plugin
      scrcpy # Remotely use android
      signal-desktop # Encrypted messaging platform
      solaar # Logitech devices manager
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
      xorg.xhost # Use x.org server with docker
      yazi # Terminal file manager
      youtube-dl # Video downloader
      zenstates # Ryzen CPU controller
    ]
    ++ codingDeps
    ++ myPackages
    ++ packageWraps
    ++ shellScripts;

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

  programs = {
    direnv.enable = true;

    zsh = {
      enable = true;
      # Enable oh my zsh and it's plugins
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "npm"
          "sudo"
          "systemd"
        ];
      };
      autosuggestions.enable = true;

      syntaxHighlighting.enable = true;

      # Aliases
      shellAliases = {
        a2c = "aria2c -j 16 -s 16"; # Download with aria using best settings
        btrfs-compress = "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
        cat = "bat"; # Better cat command
        cp = "rsync -rP"; # Copy command with details
        list-pkgs = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
        ls = "lsd"; # Better ls command
        mv = "rsync -rP --remove-source-files"; # Move command with details
        ping = "gping"; # Better ping with a graph
        reboot-uefi = "sudo systemctl reboot --firmware-setup";
        repair-store = "nix-store --verify --check-contents --repair"; # Verifies integrity and repairs inconsistencies between Nix database and store
        restart-pipewire = "systemctl --user restart pipewire";
        ssh = "TERM=xterm-256color ssh"; # SSH with colors
      };

      # Commands to run on zsh shell initialization
      interactiveShellInit = ''
        source ~/.config/zsh/zsh-theme.zsh
        unsetopt PROMPT_SP
      '';
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

  services = {
    clamav.updater.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    udev.packages = with pkgs; [
      logitech-udev-rules # Needed for solaar to work
    ];
  };
}
