{ pkgs, ... }:

pkgs.writeShellScriptBin "lout" ''
  pkill -KILL -u $USER
''
