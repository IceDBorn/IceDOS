{ config, pkgs, ... }:
{
    imports = [
        # Packages installed for all users
        ./global.nix
        # Packages installed for main user
        ./main.nix
        # Packages installed for work user
        ./work.nix
        # Home manager specific stuff
        ./home.nix
    ];

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

    # Nix Packages settings
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
}