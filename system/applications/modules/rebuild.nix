{ pkgs, config, command, update, stash }:
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

  # Navigate to configuration directory
  cd ${config.configurationLocation} 2> /dev/null ||
  (echo 'warning: configuration path is invalid, run build.sh located inside the configuration directory to update the path.' && false) &&

  if ${update}; then
    if ${stash}; then
      if [ $(git stash list | wc -l) -eq 0 ]; then
        stash
      else
        [ -n "$(git diff stash flake.lock)" ] && stash
      fi
    fi

    nix flake update && bash build.sh

    runCommand update-proton-ge
    runCommand update-wine-ge
    runCommand update-codium-extensions
  else
    bash build.sh
  fi

  runCommand patch-steam-library
''
