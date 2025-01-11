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
  environment.systemPackages = [ pkgs.gnome-control-center ];

  home-manager.users = mapAttrs (user: _: {
    xdg.desktopEntries.gnome-control-center = {
      exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
      icon = "gnome-control-center";
      name = "Gnome Control Center";
      terminal = false;
      type = "Application";
    };

    dconf.settings."org/gnome/control-center".last-panel = "online-accounts";
  }) cfg.system.users;
}
