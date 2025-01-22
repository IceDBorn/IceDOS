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
  environment.systemPackages = [ pkgs.grimblast ];

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod ALT, Print, exec, grimblast edit"
      "$mainMod CTRL SHIFT, P, exec, grimblast copy"
      "$mainMod SHIFT, P, exec, grimblast copy output"
      "$mainMod SHIFT, Print, exec, grimblast --freeze edit area"
      "$mainMod, P, exec, grimblast --freeze copy area"
      "$mainMod, Print, exec, grimblast --freeze copy area"
      ", Print, exec, grimblast copy output"
      "ALT, Print, exec, grimblast copy"
      "SHIFT, Print, exec, grimblast edit output"
    ];
  }) cfg.system.users;
}
