{ config, pkgs, ... }:
let
    unstable-channel = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
    nix-alien-pkgs = import (fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master") { };
in
{
    imports = [
        # Import home manager
        (import "${home-manager}/nixos")
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
            # Add NUR, use with "nur.repo.package"
            nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
                inherit pkgs;
            };
            # Add unstable nix channel, use with "unstable.package"
            unstable = import unstable-channel {
                config = config.nixpkgs.config;
            };
        };
    };

    # Add nix-alien
    environment.systemPackages = with nix-alien-pkgs; [
        nix-alien
        nix-index-update
        pkgs.nix-index
    ];
}
