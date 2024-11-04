{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  environment.systemPackages = [ pkgs.btop ];

  home-manager.users = mapAttrs (user: _: {
    home.file.".config/btop/btop.conf".source = ./btop.conf;
  }) cfg.system.users;
}
