{ pkgs, config, command, update, stash, main }:
pkgs.writeShellScriptBin "${command}" ''
  function stash() {
    git stash store $(git stash create) -m "flake.lock@$(date +%A-%d-%B-%T)"
  }

  function install-wine-build() {
    if command -v "$1" &> /dev/null
    then
      "$1"
    fi
  }

  # Navigate to configuration directory
  cd ${config.configurationLocation} 2> /dev/null ||
  (echo 'Configuration path is invalid. Manually run build.sh inside the configuration directory to update the path!' && false) &&

  # Update specific commands
  if ${update}; then
    # Stash the flake lock file
    if ${stash}; then
      if [ $(git stash list | wc -l) -eq 0 ]; then
        stash
      else
        [ -n "$(git diff stash flake.lock)" ] && stash
      fi
    fi

    nix flake update && bash build.sh

    if ${main}; then
      install-wine-build install-proton-ge
      install-wine-build install-wine-ge
    fi

    bash ~/.config/zsh/update-codium-extensions.sh
  else
    bash build.sh
  fi
''
