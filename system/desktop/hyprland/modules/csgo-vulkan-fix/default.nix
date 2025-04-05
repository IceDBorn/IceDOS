{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mapAttrs
    mkIf
    ;

  cfg = config.icedos;
in
mkIf (cfg.desktop.hyprland.plugins.cs2fix.enable) {
  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.csgo-vulkan-fix ];

      settings.plugin = [
        {
          csgo-vulkan-fix = {
            res_w = cfg.desktop.hyprland.cs2fix.width;
            res_h = cfg.desktop.hyprland.cs2fix.height;
            class = "cs2";
          };
        }
      ];
    };
  }) cfg.system.users;
}
