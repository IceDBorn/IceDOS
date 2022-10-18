{ config, pkgs, ... }:

{
    imports = [
        # Install gnome
        ./gnome.nix
        # Install hyprland
        ./hyprland.nix
    ];
}