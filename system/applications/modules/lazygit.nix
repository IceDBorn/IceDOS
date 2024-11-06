{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.icedos.applications;
in
mkIf (cfg.nvchad || cfg.zed.enable) {
  environment.systemPackages = [ pkgs.lazygit ];
}
