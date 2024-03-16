{ pkgs }:

pkgs.writeShellScriptBin "toggle-service" ''
  if systemctl is-active --quiet "$1"; then
      sudo systemctl stop "$1"
  else
      sudo systemctl start "$1"
  fi
''
