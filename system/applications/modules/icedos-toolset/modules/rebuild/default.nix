{
  config,
  pkgs,
  ...
}:

let
  builder =
    c: u:
    "${pkgs.writeShellScript "${c}" ''
      function cache() {
        FILE="$1"

        [ ! -f "$FILE" ] && return 1
        mkdir -p .cache

        LASTFILE=$(ls -lt ".cache" | grep "$FILE" | head -2 | tail -1 | awk '{print $9}')

        diff -sq ".cache/$LASTFILE" "$FILE" &> /dev/null || cp "$FILE" ".cache/$FILE-$(date -Is)"
      }

      function runCommand() {
        if command -v "$1" &> /dev/null
        then
          "$1"
        fi
      }

      cd ${config.icedos.configurationLocation} 2> /dev/null ||
      (echo 'warning: configuration path is invalid, run build.sh located inside the configuration scripts directory to update the path.' && false) &&

      cache "flake.nix"

      if ${u}; then
        nix-shell ./build.sh --update $@ && cache "flake.lock" || true
        runCommand update-codium-extensions
      else
        nix-shell ./build.sh $@
      fi
    ''}";
in
{
  icedos.internals.toolset.commands = [
    (
      let
        command = "rebuild";
      in
      {
        bin = toString (builder command "false");
        command = command;
        help = "rebuild the system";
      }
    )

    (
      let
        command = "update";
      in
      {
        bin = toString (builder command "true");
        command = command;
        help = "update flake.lock and rebuild the system";
      }
    )
  ];
}
