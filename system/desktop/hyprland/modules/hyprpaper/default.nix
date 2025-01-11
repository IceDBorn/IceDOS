{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  environment.systemPackages = [ pkgs.hyprpaper ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/.config/hypr/hyprpaper.jpg
        wallpaper = , ~/.config/hypr/hyprpaper.jpg
        ipc = off
      '';

      ".config/hypr/hyprpaper.jpg".source = ./hyprpaper.jpg;
    };
  }) cfg.system.users;
}
