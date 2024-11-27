{ pkgs, ... }:

pkgs.writeShellScriptBin "trim-generations" (builtins.readFile ../../../scripts/trim-generations.sh)
