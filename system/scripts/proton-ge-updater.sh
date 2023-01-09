#!/bin/bash

currentVersion=$(ls /etc/proton-ge-nix)
installedVersions=$(ls $HOME/.local/share/Steam/compatibilitytools.d/ 2> /dev/null)
isInstalled=false

function installProtonGE () {
	mkdir -p $HOME/.local/share/Steam/compatibilitytools.d/
	sudo cp -r /etc/proton-ge-nix/* $HOME/.local/share/Steam/compatibilitytools.d/
	sudo chown -R $username:users $HOME/.local/share/Steam/compatibilitytools.d/
	sudo chmod -R 775 $HOME/.local/share/Steam/compatibilitytools.d/
}

if [ -z "$installedVersions" ]
then
	echo "Installing latest proton ge..."
	installProtonGE
	isInstalled=true
else
	while IFS= read -r version ; do
		if [ "$version" == "$currentVersion" ]
		then
			isInstalled=true
			echo "Latest proton ge is already installed..."
			break
		fi
	done <<< "$installedVersions"
fi

if [ $isInstalled == false ]
then
	echo "Installing latest proton ge..."
	installProtonGE
fi
