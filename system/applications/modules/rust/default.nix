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
mkIf (cfg.rust) {
  environment.systemPackages = with pkgs; [
    cargo # Package manager
    rust-analyzer # Language server
    rustfmt # Formatter
  ];
}
