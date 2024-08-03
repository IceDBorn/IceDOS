{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) foldl' lists splitString;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;

  pkgFile = lib.importTOML ./packages.toml;

  cfg = config.icedos;

  codingDeps = (pkgMapper pkgFile.codingDeps);

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
  imports = [
    ./modules/android-tools.nix
    ./modules/aria2c.nix
    ./modules/brave.nix
    ./modules/celluloid.nix
    ./modules/clamav.nix
    ./modules/codium
    ./modules/container-manager.nix
    ./modules/gamemode.nix
    ./modules/kitty.nix
    ./modules/librewolf
    ./modules/libvirtd.nix
    ./modules/mangohud.nix
    ./modules/nvchad
    ./modules/steam.nix
    ./modules/sunshine.nix
    ./modules/waydroid.nix
  ];

  boot.kernelPackages =
    # Use CachyOS optimized linux kernel
    if
      (
        !cfg.hardware.devices.steamdeck
        && !cfg.hardware.devices.server.enable
        && builtins.pathExists /etc/icedos-version
      )
    then
      pkgs.linuxPackages_cachyos
    else if (cfg.hardware.devices.server.enable && builtins.pathExists /etc/icedos-version) then
      pkgs.linuxPackages_cachyos-server
    else
      pkgs.linuxPackages_zen;

  environment.systemPackages =
    (pkgMapper pkgFile.packages) ++ codingDeps ++ packageWraps ++ shellScripts;

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
        btrfs-compress = "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
        cat = "bat"; # Better cat command
        cp = "rsync -rP"; # Copy command with details
        df = "duf"; # Better disk usage utility
        list-pkgs = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
        ls = "lsd"; # Better ls command
        mv = "rsync -rP --remove-source-files"; # Move command with details
        ping = "gping"; # Better ping with a graph
        reboot-uefi = "sudo systemctl reboot --firmware-setup";
        repair-store = "nix-store --verify --check-contents --repair"; # Verifies integrity and repairs inconsistencies between Nix database and store
        ssh = "TERM=xterm-256color ssh"; # SSH with colors
      };

      # Commands to run on zsh shell initialization
      interactiveShellInit = ''
        source ~/.config/zsh/zsh-theme.zsh
        unsetopt PROMPT_SP
      '';
    };
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    udev.packages = with pkgs; [
      logitech-udev-rules # Needed for solaar to work
    ];
  };
}
