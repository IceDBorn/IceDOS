{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.sunshine;
in
mkIf (cfg.enable) {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    autoStart = cfg.autostart;
  };
}
