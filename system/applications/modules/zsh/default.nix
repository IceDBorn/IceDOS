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
    programs.zsh.enable = true;

    home.file = {
      ".config/zsh/p10k.zsh".source =
        "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      ".config/zsh/p10k-theme.zsh".source = ./p10k-theme.zsh;
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
      btrfs-compress = "sudo btrfs filesystem defrag -czstd -r -v";
      reboot-uefi = "sudo systemctl reboot --firmware-setup";
      ssh = "TERM=xterm-256color ssh";
    };

    interactiveShellInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
      [[ ! -f ~/.config/zsh/p10k-theme.zsh ]] || source ~/.config/zsh/p10k-theme.zsh
      unsetopt PROMPT_SP
    '';
  };

  users.defaultUserShell = pkgs.zsh;
}
