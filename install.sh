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
  # Add configuration files to the appropriate path
  sudo cp configuration.nix /etc/nixos
  sudo cp mounts.nix /etc/nixos
  sudo cp -r configs /etc/nixos
  sudo cp -r scripts /etc/nixos

  # Build the configuration
  sudo nixos-rebuild switch || exit

  # Install discord-screenaudio
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install de.shorsh.discord-screenaudio

  ### ARKENFOX JS ###
  USERS=$(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1) # Get all users

  if [ -z "$USERS" ]
  then
      echo "No users available to install arkenfox js..."
  else
    # Download the updater
    git clone https://github.com/arkenfox/user.js.git
    while IFS= read -r user ; do
      # Install the updater for all users
      echo "Installing arkenfox js for $RED$BOLD$user$NC$NORMAL!"
      sudo cp user.js/updater.sh /home/"$user"/.mozilla/privacy
      sudo chown "$user":"$user" /home/"$user"/.mozilla/privacy/updater.sh
    done <<< "$USERS"
    # Remove the arkenfox js folder
    rm -rf user.js
  fi

  # Reboot after the installation is completed
  bash scripts/reboot.sh

else
  printf "You really should:
  - Edit configuration.nix and comment out anything you do not want to setup.
  - Replace hardware-configuration.nix with yours or do not install it.$RED$BOLD A wrong hardware-configuration.nix file can break your system!$NC$NORMAL
  - Edit scripts/zenstates.sh or do not install it. $RED$BOLD A non-configured zenstates.sh file can break your cpu!$NC$NORMAL
  - Edit configs/user-overrides.js to customize your firefox custom user settings appending the updater's 'user.js'.\n"
fi
