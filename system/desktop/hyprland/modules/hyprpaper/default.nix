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
    home.file = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/.config/hypr/hyprpaper.jpg
        wallpaper = , ~/.config/hypr/hyprpaper.jpg
        ipc = off
      '';

      ".config/hypr/hyprpaper.jpg".source = ./hyprpaper.jpg;
    };

    systemd.user.services.hyprpaper = {
      Unit.Description = "Hyprpaper - Wallpaper Manager";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${package}/bin/hyprpaper";
        Nice = "-20";
        Restart = "on-failure";
        StartLimitIntervalSec = 60;
        StartLimitBurst = 60;
      };
    };
  }) cfg.system.users;
}
