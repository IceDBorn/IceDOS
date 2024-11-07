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
  environment.systemPackages = [ pkgs.rofi-wayland ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/rofi/config.rasi" = {
        source = ./config.rasi;
      };

      ".config/rofi/theme.rasi" = {
        source = ./theme.rasi;
      };
    };
  }) cfg.system.users;
}
