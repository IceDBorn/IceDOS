{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
in
mkIf (cfg.hardware.bluetooth) {
  environment.systemPackages = mkIf (cfg.desktop.hyprland.enable) [ pkgs.blueberry ];

  hardware = {
    bluetooth.enable = true;
    xpadneo.enable = cfg.hardware.drivers.xpadneo;
  };
}
