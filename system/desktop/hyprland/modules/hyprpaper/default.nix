{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
  package = pkgs.hyprpaper;
in
{
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/hypr/hyprpaper.jpg".source = ./hyprpaper.jpg;

    services.hyprpaper = {
      enable = true;

      settings = {
        preload = "~/.config/hypr/hyprpaper.jpg";
        wallpaper = ", ~/.config/hypr/hyprpaper.jpg";
        ipc = "off";
      };
    };
  }) cfg.system.users;
}
