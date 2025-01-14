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
mkIf (cfg.php) {
  environment.systemPackages = with pkgs; [
    nodePackages.intelephense # Language server
    phpPackages.phpstan # Static Analysis Tool
    php # An HTML-embedded scripting language
    phpPackages.composer # Dependency Manager
  ];
}
