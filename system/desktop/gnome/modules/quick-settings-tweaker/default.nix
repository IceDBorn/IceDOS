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
  environment.systemPackages = [ pkgs.gnomeExtensions.quick-settings-tweaker ];

  home-manager.users = mapAttrs (user: _: {
    dconf.settings."org/gnome/shell".enabled-extensions = [ "quick-settings-tweaks@qwreey" ];
  }) cfg.system.users;
}
