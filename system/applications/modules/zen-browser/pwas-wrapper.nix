{ config, pkgs }:

let
  cfg = config.icedos.applications.zen-browser.pwas;
in
pkgs.writeShellScriptBin "zen-pwas" "zen --no-remote -P PWAs --name pwas ${builtins.toString cfg.sites}"
