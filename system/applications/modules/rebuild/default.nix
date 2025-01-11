{
  config,
  pkgs,
  ...
}:

let
  builder =
    c: u:
    pkgs.writeShellScriptBin "${c}" ''
      function cache() {
        FILE="$1"

        [ ! -f "$FILE" ] && exit 1
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
    '';

in
{
  environment.systemPackages = [
    (builder "rebuild" "false")
    (builder "update" "true")
  ];
}
