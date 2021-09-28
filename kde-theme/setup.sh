#!/bin/bash

echo "Installing Fluent KDE theme"
git clone https://github.com/vinceliuice/Fluent-kde.git
cd Fluent-kde || exit
latest=$(git describe --abbrev=0 --tags)
git checkout tags/"$latest"
./install.sh --round
