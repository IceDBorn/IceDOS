{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    programs = {
      zsh = {
        enable = true;

        # Install powerlevel10k
        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            src = zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
        ];
      };
    };

    home.file = {
      # Add zsh theme to zsh directory
      ".config/zsh/zsh-theme.zsh".source = ./theme.zsh;
    };
  }) cfg.system.users;

  programs.zsh = {
    enable = true;

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

    interactiveShellInit = ''
      source ~/.config/zsh/zsh-theme.zsh
      unsetopt PROMPT_SP
    '';
  };

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users
}
