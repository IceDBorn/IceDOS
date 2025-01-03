{
  pkgs,
  config,
  command,
  update,
}:
pkgs.writeShellScriptBin "${command}" ''
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

  # Retain sudo
  trap "exit" INT TERM; trap "kill 0" EXIT; sudo -v || exit $?; sleep 1; while true; do sleep 60; sudo -nv; done 2>/dev/null &

  # Navigate to configuration directory
  cd ${config.icedos.configurationLocation} 2> /dev/null ||
  (echo 'warning: configuration path is invalid, run build.sh located inside the configuration scripts directory to update the path.' && false) &&

  cache "flake.nix"

  if ${update}; then
  	nix flake update && cache "flake.lock" || true
  	sudo nix-shell scripts/build.sh $@

  	runCommand update-codium-extensions
  else
  	sudo bash scripts/build.sh $@
  fi
''
