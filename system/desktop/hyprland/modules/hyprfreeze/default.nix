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
  environment.systemPackages = [ pkgs.hyprfreeze ];

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = [ "$mainMod CTRL SHIFT, F, exec, hyprfreeze -a" ];
  }) cfg.system.users;
}
