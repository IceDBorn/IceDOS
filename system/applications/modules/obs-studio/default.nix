{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.obs-studio;
in
mkIf (cfg.enable) {
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = cfg.virtualCamera;
  };
}
