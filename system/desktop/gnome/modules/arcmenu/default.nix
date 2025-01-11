{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) map mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf cfg.desktop.gnome.extensions.arcmenu {
  environment.systemPackages = [ pkgs.gnomeExtensions.arcmenu ];

  home-manager.users = mapAttrs (user: _: {
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ "arcmenu@arcmenu.com" ];
      };

      "org/gnome/shell/extensions/arcmenu" = {
        distro-icon = 6;
        menu-button-icon = "Distro_Icon"; # Use arch icon
        multi-monitor = true;
        menu-layout = "Windows";
        windows-disable-frequent-apps = true;
        windows-disable-pinned-apps = !cfg.system.users.${user}.desktop.gnome.pinnedApps.arcmenu.enable;
        pinned-apps =
          with inputs.home-manager.lib.hm.gvariant;
          (map (s: [
            (mkDictionaryEntry [
              "id"
              s
            ])
          ]) cfg.system.users.${user}.desktop.gnome.pinnedApps.arcmenu.list);
      };
    };
  }) cfg.system.users;
}
