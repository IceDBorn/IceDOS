#!/usr/bin/env bash

handleReboot() {
    echo "Rebooting, abort by pressing 'CTRL + C'"
    for i in {10..1}
    do
        if [ "$i" -eq "1" ]; then
            echo -en "\rRebooting in $i second... "
        else
            echo -en "\rRebooting in $i seconds..."
        fi
        sleep 1
    done

    reboot
}

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
    handleReboot

    if [ -f "etc/icedos-version" ]
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
