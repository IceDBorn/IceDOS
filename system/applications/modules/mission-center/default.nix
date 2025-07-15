{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
  package = pkgs.mission-center;
in
mkIf (cfg.applications.mission-center) {
  environment.systemPackages = [ package ];

  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland.settings.bind = mkIf (cfg.desktop.hyprland.enable) [
      "CTRL SHIFT, ESCAPE, exec, ${package}/bin/missioncenter"
    ];
  }) cfg.system.users;
}
