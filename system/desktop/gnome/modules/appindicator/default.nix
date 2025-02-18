{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  environment.systemPackages = [
    pkgs.gnomeExtensions.appindicator
  ];

  home-manager.users = mapAttrs (user: _: {
    dconf.settings."org/gnome/shell".enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
  }) cfg.system.users;
}
