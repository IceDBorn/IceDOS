{
  pkgs,
  config,
  command,
  update,
  stash,
}:
pkgs.writeShellScriptBin "${command}" ''
  function stash() {
    git stash store $(git stash create) -m "flake.lock@$(date +%A-%d-%B-%T)"
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

  if ${update}; then
    if ${stash}; then
      if [ $(git stash list | wc -l) -eq 0 ]; then
        stash
      else
        [ -n "$(git diff stash flake.lock)" ] && stash
      fi
    fi

    nix flake update && sudo bash scripts/build.sh

    runCommand update-proton-ge
    runCommand update-wine-ge
    runCommand update-codium-extensions
  else
    sudo bash scripts/build.sh
  fi

  runCommand patch-steam-library
''
