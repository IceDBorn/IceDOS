{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf optional;
  cfg = config.icedos.applications.tailscale;
in
mkIf (cfg.enable) {
  environment.systemPackages = with pkgs; [ tailscale ] ++ optional (cfg.enableTrayscale) trayscale;
  services.tailscale.enable = true;
}
