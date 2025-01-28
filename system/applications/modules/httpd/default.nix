{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.httpd;
in
mkIf (cfg.enable) {
  services.httpd = {
    enable = true;
    user = cfg.user;
    enablePHP = cfg.php;
  };
}
