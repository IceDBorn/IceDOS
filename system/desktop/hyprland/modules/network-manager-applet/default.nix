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
  home-manager.users = mapAttrs (user: _: {
    xdg.desktopEntries.nm-connection-editor = {
      exec = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      icon = "epiphany";
      name = "Network Connection Editor";
      terminal = false;
      type = "Application";
    };
  }) cfg.system.users;
}
