#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

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
    USERS=$(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1) # Get all users

    if [ -z "$USERS" ]
    then
        echo "No users available to remove firefox profiles ini..."
    else
        while IFS= read -r user ; do
            # Remove potentially generated firefox profiles ini before building the nix configuration
            echo "Removing firefox profiles ini for $user..."
            sudo rm -rf /home/$user/.mozilla/firefox/profiles.ini 2> /dev/null
        done <<< "$USERS"
    fi

    bash ./rebuild.sh

    if [ -f "$HOME/.nix-successful-build" ]
    then
        echo "Nix generation was successful!"
        bash system/scripts/reboot.sh
    else
        echo "Nix generation was not successful!"
    fi
else
    printf "You really should:
  - Edit .nix, configuration.nix and comment out anything you do not want to setup.
    - Edit mounts.nix or disable it.$RED$BOLD An invalid mounts.nix configuration can break your system!$NC$NORMAL\n"
fi
