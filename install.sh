#!/bin/bash

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

    # Settings changer
    bash settings/settings.sh

    # Rebooting sequence
    bash scripts/reboot.sh
else
  printf "You really should:
  - Edit main-setup.sh and comment out any script you do not want to run.
  - Edit settings/fstab.txt or do not install it.$RED$BOLD A non-configured fstab file can break your system!$NC$NORMAL
  - Edit settings/services/zenstates.sh or do not install it. $RED$BOLD A non-configured zenstates.sh file can break your cpu!$NC$NORMAL
  - Edit pacman and aur packages lists in apps/packages.
  - Edit install-apps.sh to remove installation of extra apps not present in pacman and aur.
  - Edit settings/settings.sh and comment out the parts you do not want to setup.
  - Edit settings/user-overrides to customize your firefox custom user settings appending the updater's 'user.js'.\n"
fi
