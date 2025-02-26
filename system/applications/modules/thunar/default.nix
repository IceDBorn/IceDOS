{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.thunar.enable) {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # Create/Extract archives
      thunar-volman # Removable media management
      tumbler # Media files thumbnails
    ];
  };

  icedos.internals.xfce4.files = {
    "xfconf/xfce-perchannel-xml/thunar.xml".source = ./thunar.xml;
  };
}
