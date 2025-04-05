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
    (
      let
        purpleString = string: ''''${PURPLE}${string}''${NC}'';
      in
      pkgs.writeShellScriptBin "icedos" ''
        PURPLE='\033[0;35m'
        NC='\033[0m'

        if [[ "$1" == "" || "$1" == "help" ]]; then
          echo "Available commands:"

          ${concatMapStrings (tool: ''
            echo -e "> ${purpleString tool.command}: ${tool.help} "
          '') cfg.internals.toolset.commands}

          exit 0
        fi

        case "$1" in
          ${concatMapStrings (tool: ''
            ${tool.command})
              shift
              exec ${tool.bin} "$@"
              ;;
          '') cfg.internals.toolset.commands}
          *|-*|--*)
            echo "Unknown arg: $1" >&2
            exit 1
            ;;
        esac
      ''
    )
  ];
}
