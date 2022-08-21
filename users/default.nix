{ config, pkgs, ... }:

{
    imports = [
        ./main.nix
        ./work.nix
    ];

    # Set default shell to zsh
    users.defaultUserShell = pkgs.zsh;
}