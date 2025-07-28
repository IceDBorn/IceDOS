{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos;
  lsfg-vk = cfg.applications.lsfg-vk;
in
mkIf (lsfg-vk) {
  services.lsfg-vk = {
    enable = true;
    ui.enable = true;
  };
}
