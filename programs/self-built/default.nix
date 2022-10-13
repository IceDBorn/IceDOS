{ config, pkgs, ... }:

{
    imports = [
        # PWAs for Firefox
        #./firefox-pwas.nix

        # Proton GE Downloader
        ./protonup-ng.nix

        # Streaming server
        #./sunshine.nix

        # Task manager
        ./system-monitoring-center.nix
    ];
}