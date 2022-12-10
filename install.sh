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
	# Add configuration files to the appropriate path
	sudo cp -r bootloader /etc/nixos
	sudo cp -r hardware /etc/nixos
	sudo cp -r system /etc/nixos
	sudo cp .configuration-location /etc/nixos
	sudo cp configuration.nix /etc/nixos
	sudo cp flake.lock /etc/nixos
	sudo cp flake.nix /etc/nixos

	# Remove potentially generated firefox profiles before installing the nix configuration
	sudo rm -rf /home/$username/.mozilla/firefox/profiles.ini

	# Build the configuration
	sudo nixos-rebuild switch || exit

	# Install flatpak apps
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install de.shorsh.discord-screenaudio com.github.tchx84.Flatseal io.github.spacingbat3.webcord
	# Use the same cursor theme normal apps use
	flatpak --user override --filesystem=/etc/bibata-cursors/:ro

	# Download proton ge
	protonup -d "$HOME/.steam/root/compatibilitytools.d/" && protonup

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
			echo "Installing arkenfox js for $user..."
			sudo cp user.js/updater.sh /home/"$user"/.mozilla/firefox/privacy
			sudo chown "$user":users /home/"$user"/.mozilla/firefox/privacy/updater.sh
			yes | sudo bash /home/"$user"/.mozilla/firefox/privacy/updater.sh
			sudo chown "$user":users /home/"$user"/.mozilla/firefox/privacy/user.js
		done <<< "$USERS"
		# Remove git folder
		rm -rf user.js
	fi

	# Reboot after the installation is completed
	bash scripts/reboot.sh

else
	printf "You really should:
	- Edit configuration.nix and comment out anything you do not want to setup.
	- Edit mounts.nix or do not install it.$RED$BOLD A wrong mounts.nix file can break your system!$NC$NORMAL\n"
fi
