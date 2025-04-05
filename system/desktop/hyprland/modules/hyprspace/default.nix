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

  accentColor =
    if (!cfg.desktop.gnome.enable) then
      "0xee${cfg.desktop.accentColor}"
    else
      {
        blue = "0xee3584e4";
        green = "0xee3a944a";
        orange = "0xeeed5b00";
        pink = "0xeed56199";
        purple = "0xee9141ac";
        red = "0xeee62d42";
        slate = "0xee6f8396";
        teal = "0xee2190a4";
        yellow = "0xeec88800";
      }
      .${cfg.desktop.gnome.accentColor};
in
mkIf (cfg.desktop.hyprland.plugins.hyprspace) {
  home-manager.users = mapAttrs (user: _: {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.hyprspace ];

      settings = {
        bind = [
          "$mainMod, TAB, overview:toggle"
          "$mainMod SHIFT, TAB, overview:toggle, all"
        ];

        plugin = [
          {
            overview = {
              gapsIn = 5;
              gapsOut = 5;
              panelHeight = 100;
              showEmptyWorkspace = false;
              showNewWorkspace = false;
              workspaceActiveBorder = accentColor;
            };
          }
        ];
      };
    };
  }) cfg.system.users;
}
