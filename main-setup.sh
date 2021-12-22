#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

username=$(whoami)

echo "Hello $username!"

read -r -p "Have you customized the setup to your needs? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Applications installer
    bash ./apps/install-apps.sh

    # Application configs installer
    bash ./apps/install-app-configs.sh

    # Settings changer
    bash ./settings/settings.sh

    # Zsh installer
    bash ./apps/zsh/zsh-setup.sh

    # TODO: Add one time service at next boot
    # Photoshop installer
    #bash ./apps/install-photoshop.sh

    # Rebooting sequence
    bash ./scripts/reboot.sh
else
  printf "You really should:
  - Edit main-setup.sh and comment out any script you do not want to run.
  - Edit settings/fstab or remove it entirely.$RED$BOLD A non-configured fstab file can break your system!$NC$NORMAL
  - Edit pacman and yay packages lists in apps/packages.
  - Edit install-apps.sh to remove installation of extra apps not present in pacman and yay.
  - Remove custom application entries you do not want in settings/applications.
  - Remove autostart entries you do not want in settings/autostart.
  - Remove services you do not want to run on startup in settings/services.
  - Edit settings/settings.sh and comment out the parts you do not want to setup.
  - Edit settings/user-overrides if you're using firefox.\n"
fi
