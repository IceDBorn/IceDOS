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
  environment.systemPackages = [ pkgs.playerctl ];

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
    ];
  }) cfg.system.users;
}
