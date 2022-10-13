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
  sudo cp -r boot /etc/nixos
  sudo cp -r configs /etc/nixos
  sudo cp -r desktop /etc/nixos
  sudo cp -r hardware /etc/nixos
  sudo cp -r programs /etc/nixos
  sudo cp -r scripts /etc/nixos
  sudo cp -r startup /etc/nixos
  sudo cp -r users /etc/nixos
  sudo cp configuration.nix /etc/nixos

  # Build the configuration
  sudo nixos-rebuild switch || exit

  # Add repos to this installation and to each user
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo -u main remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  sudo -u work remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  # Install flatpak apps globally
  flatpak install de.shorsh.discord-screenaudio com.discordapp.Discord com.github.tchx84.Flatseal com.mattjakeman.ExtensionManager com.usebottles.bottles

  # Install flatpak apps only for work user
  sudo -u work flatpak install --user com.slack.Slack

  # Use the same cursor theme normal apps use
  flatpak --user override --filesystem=/etc/bibata-cursors/:ro
  # Patch the flatpak nvidia drivers for nvfbc support
  git clone https://github.com/keylase/nvidia-patch.git
  sudo bash nvidia-patch/patch-fbc.sh -f
  cp -r nvidia-patch

  # Download proton ge
  protonup -d "$HOME/.steam/root/compatibilitytools.d/" && protonup

  ### NVIDIA-PATCH ###
  USERS=$(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1) # Get all users

  if [ -z "$USERS" ]
  then
      echo "No users available to install nvidia-patch..."
  else
    while IFS= read -r user ; do
      # Install nvidia-patch for main user
      echo "Installing nvidia-patch for $user..."
      if [[ -d /home/"$user"/.config/zsh/nvidia-patch ]]
      then
          cp -r nvidia-patch /home/"$user"/.config/zsh
      fi
    done <<< "$USERS"
    # Remove nvidia-patch folder
    rm -rf nvidia-patch
  fi

  # Reboot after the installation is completed
  bash scripts/reboot.sh

else
  printf "You really should:
  - Edit configuration.nix and comment out anything you do not want to setup.
  - Edit mounts.nix or do not install it.$RED$BOLD A wrong mounts.nix file can break your system!$NC$NORMAL\n"
fi
