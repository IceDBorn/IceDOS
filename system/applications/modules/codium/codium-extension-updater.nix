{ config, pkgs }:

let
  cfg = config.icedos.applications.codium;
in
pkgs.writeShellScriptBin "update-codium-extensions" ''
  EXTENSIONS=(${cfg.extensions})

  echo "updating codium extensions..."
  echo "''${EXTENSIONS[*]}" | xargs -P "$(nproc)" -n 1 codium --force --install-extension > /dev/null
''
