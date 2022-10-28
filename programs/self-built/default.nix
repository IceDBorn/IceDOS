{ config, pkgs, ... }:

{
    imports = [
        # Proton GE Downloader
        ./protonup-ng.nix

        # Task manager
        #./system-monitoring-center.nix
    ];
}