{ config, pkgs }:

let
  cfg = config.icedos.applications.librewolf;
in
pkgs.writeShellScriptBin "librewolf-pwas" "librewolf --no-remote -P PWAs --name pwas ${cfg.pwas}"
