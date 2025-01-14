{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.icedos.applications.librewolf;
in
{
  environment.systemPackages = mkIf (cfg.enable && cfg.pwas.enable) [
    (pkgs.writeShellScriptBin "librewolf-pwas" "librewolf --no-remote -P PWAs --name pwas ${builtins.toString cfg.pwas.sites}")
  ];
}
