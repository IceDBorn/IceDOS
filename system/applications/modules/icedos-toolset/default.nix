{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatMapStrings;
  cfg = config.icedos;
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "icedos" ''
      if [[ "$1" == "" || "$1" == "help" ]]; then
        ${concatMapStrings (tool: ''
          echo "${tool.command}: ${tool.help}"
        '') cfg.internals.icedos-toolset.commands}
        exit 0
      fi

      case "$1" in
        ${concatMapStrings (tool: ''
          ${tool.command})
            shift
            exec ${tool.bin} "$@"
            ;;
        '') cfg.internals.icedos-toolset.commands}
        *|-*|--*)
          echo "Unknown arg: $1" >&2
          exit 1
          ;;
      esac
    '')
  ];
}
