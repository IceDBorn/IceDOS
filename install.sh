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
	sudo cp .nix /etc/nixos
	sudo cp configuration.nix /etc/nixos
	sudo cp flake.lock /etc/nixos
	sudo cp flake.nix /etc/nixos

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

	# Build the configuration
	sudo nixos-rebuild switch || exit

	# Initialise apx
	apx init --aur
	docker exec -it apx_managed_aur su - $username bash -c "sudo pacman -S --needed git base-devel wget file && cd .cache && wget https://github.com/Jguer/yay/releases/download/v11.3.2/yay_11.3.2_x86_64.tar.gz -O yay.tar.gz && tar -xzf yay.tar.gz && rm -rf yay.tar.gz && sh -c '$(find ~/.cache -wholename '*/yay' | tail -n1) -S yay'"

	# Reboot after the installation is completed
	bash scripts/reboot.sh

else
	printf "You really should:
	- Edit .nix, configuration.nix and comment out anything you do not want to setup.
	- Edit mounts.nix or disable it.$RED$BOLD A wrong mounts.nix file can break your system!$NC$NORMAL\n"
fi
