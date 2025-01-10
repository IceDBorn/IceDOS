{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.signal;

  package =
    with pkgs;
    {
      flare = flare-signal;
      signal = signal-desktop;
    }
    .${cfg.package};
in
mkIf (cfg.enable) {
  environment.systemPackages = [ package ];
}
