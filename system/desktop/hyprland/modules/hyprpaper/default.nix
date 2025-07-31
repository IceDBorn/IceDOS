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
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = "~/Pictures/wallpaper.jpg";
        wallpaper = ", ~/Pictures/wallpaper.jpg";
        ipc = "off";
      };
    };
  }) cfg.system.users;
}
