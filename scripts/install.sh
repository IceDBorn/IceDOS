#!/usr/bin/env bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit

RED='\033[0;31m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

username=$(whoami)
export username

echo "Hello $username!"

read -r -p "Have you customized the setup to your needs? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    bash scripts/build.sh

    if [ -f "$HOME/.nix-successful-build" ]
    then
        echo "Nix generation was successful!"
        bash scripts/reboot.sh
    else
        echo "Nix generation was not successful!"
    fi
else
    printf "You really should:
  - Edit .nix, configuration.nix and comment out anything you do not want to setup.
    - Edit mounts.nix or disable it.$RED$BOLD An invalid mounts.nix configuration can break your system!$NC$NORMAL\n"
fi
