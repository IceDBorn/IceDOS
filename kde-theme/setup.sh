#!/bin/bash

echo "Installing Fluent KDE theme"
git clone https://github.com/vinceliuice/Fluent-kde.git
cd Fluent-kde || exit
latest=$(git describe --abbrev=0 --tags)
git checkout tags/"$latest"
./install.sh --round
lookandfeeltool -a com.github.vinceliuice.Fluent-round-dark
/usr/lib/plasma-changeicons Papirus-Dark