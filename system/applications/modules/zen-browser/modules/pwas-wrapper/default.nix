{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.zen-browser;
in
{
  environment.systemPackages = mkIf (cfg.enable && cfg.pwas.enable) [
    (pkgs.writeShellScriptBin "zen-pwas" "zen --no-remote -P PWAs --name pwas ${builtins.toString cfg.pwas.sites}")
  ];
}
